import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/crash_analysis_service.dart';
import '../models/diagnostic_model.dart';
import '../models/maintenance_log_model.dart';

abstract interface class IDiagnosticsRemoteDataSource {
  Future<DiagnosticModel> getDiagnostics(String bikeId);
  Future<List<MaintenanceLogModel>> getMaintenanceLogs(String bikeId);
}

@LazySingleton(as: IDiagnosticsRemoteDataSource)
class DiagnosticsRemoteDataSource implements IDiagnosticsRemoteDataSource {
  DiagnosticsRemoteDataSource(this._client)
    : _telemetryClient = SupabaseClient(
        AppConfig.supabaseUrl,
        AppConfig.supabasePublishableKey,
      );
  final SupabaseClient _client;
  final SupabaseClient _telemetryClient;

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
        Map<String, dynamic>.from(rows.first as Map),
      );
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
    final rows = await _telemetryClient
        .from('ebike_telemetry')
        .select('id,recorded_at,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z')
        .eq('device_id', deviceId)
        .or(
          'accel_x.gte.1.4,accel_x.lte.-1.4,'
          'accel_y.gte.1.4,accel_y.lte.-1.4,'
          'accel_z.gte.1.4,accel_z.lte.-1.4,'
          'gyro_x.gte.69,gyro_x.lte.-69,'
          'gyro_y.gte.69,gyro_y.lte.-69,'
          'gyro_z.gte.69,gyro_z.lte.-69',
        )
        .order('recorded_at', ascending: false)
        .limit(5000);
    if ((rows as List).isEmpty) {
      throw ServerException(message: 'No crash telemetry found');
    }

    final events = CrashAnalysisService.analyze(
      rows.map((raw) => Map<String, dynamic>.from(raw as Map)).toList(),
    );
    final latestCrash = events.isEmpty ? null : events.first;
    final hasCrash = latestCrash != null;
    final critical = latestCrash?.isCritical ?? false;
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
                    '${latestCrash.phaseSummary}; ${latestCrash.peakImpactG.toStringAsFixed(1)} g and ${latestCrash.peakRotationDps.toStringAsFixed(0)}°/s',
                severity: critical ? 'critical' : 'major',
                detectedAt: latestCrash.detectedAt.toIso8601String(),
                isActive: true,
              ),
            ]
          : [],
      lastDiagnosticAt: latest['recorded_at'].toString(),
      maintenanceStatus: critical ? 'overdue' : (hasCrash ? 'dueSoon' : 'ok'),
    );
  }

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
          .map((r) => MaintenanceLogModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
