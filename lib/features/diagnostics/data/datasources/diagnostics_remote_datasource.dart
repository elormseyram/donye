import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/diagnostic_model.dart';
import '../models/maintenance_log_model.dart';

abstract interface class IDiagnosticsRemoteDataSource {
  Future<DiagnosticModel> getDiagnostics(String bikeId);
  Future<List<MaintenanceLogModel>> getMaintenanceLogs(String bikeId);
}

@LazySingleton(as: IDiagnosticsRemoteDataSource)
class DiagnosticsRemoteDataSource implements IDiagnosticsRemoteDataSource {
  const DiagnosticsRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<DiagnosticModel> getDiagnostics(String bikeId) async {
    try {
      final rows = await _client
          .from('diagnostics')
          .select('*, fault_codes(*)')
          .eq('bike_id', bikeId)
          .order('last_diagnostic_at', ascending: false)
          .limit(1);
      if ((rows as List).isEmpty) {
        throw ServerException(message: 'No diagnostics found');
      }
      return DiagnosticModel.fromJson(
          Map<String, dynamic>.from(rows.first as Map));
    } catch (e) {
      try {
        return await _getCrashDiagnostics(bikeId);
      } catch (_) {
        if (e is ServerException) rethrow;
        throw ServerException(message: e.toString());
      }
    }
  }

  Future<DiagnosticModel> _getCrashDiagnostics(String bikeId) async {
    final deviceId = AppConfig.mqttBikeId;
    if (deviceId.isEmpty) {
      throw ServerException(message: 'MQTT bike ID is not configured');
    }
    final rows = await _client
        .from('ebike_telemetry')
        .select('id,recorded_at,accel_x,accel_y,accel_z')
        .eq('device_id', deviceId)
        .order('recorded_at', ascending: false)
        .limit(500);
    if ((rows as List).isEmpty) {
      throw ServerException(message: 'No crash telemetry found');
    }

    Map<String, dynamic>? strongest;
    var strongestImpact = 0.0;
    for (final raw in rows) {
      final row = Map<String, dynamic>.from(raw as Map);
      final x = _number(row['accel_x']);
      final y = _number(row['accel_y']);
      final z = _number(row['accel_z']);
      final impact = math.sqrt(x * x + y * y + z * z);
      if (impact > strongestImpact) {
        strongestImpact = impact;
        strongest = row;
      }
    }

    final hasCrash = strongestImpact >= 3.0;
    final critical = strongestImpact >= 5.0;
    final latest = Map<String, dynamic>.from(rows.first as Map);
    return DiagnosticModel(
      id: 'telemetry-${latest['id']}',
      bikeId: bikeId,
      healthScore: critical ? 35 : (hasCrash ? 70 : 100),
      faultCodes: hasCrash
          ? [
              FaultCodeModel(
                code: 'CRASH_IMPACT',
                description:
                    '${strongestImpact.toStringAsFixed(1)} g impact detected',
                severity: critical ? 'critical' : 'major',
                detectedAt: strongest?['recorded_at']?.toString() ??
                    latest['recorded_at'].toString(),
                isActive: true,
              ),
            ]
          : [],
      lastDiagnosticAt: latest['recorded_at'].toString(),
      maintenanceStatus: critical ? 'overdue' : (hasCrash ? 'dueSoon' : 'ok'),
    );
  }

  double _number(Object? value) => double.tryParse('$value') ?? 0.0;

  @override
  Future<List<MaintenanceLogModel>> getMaintenanceLogs(String bikeId) async {
    try {
      final rows = await _client
          .from('maintenance_logs')
          .select()
          .eq('bike_id', bikeId)
          .order('performed_at', ascending: false)
          .limit(50);
      return (rows as List)
          .map((r) =>
              MaintenanceLogModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
