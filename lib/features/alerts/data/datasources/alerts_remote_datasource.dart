import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/crash_analysis_service.dart';
import '../models/alert_model.dart';

abstract class IAlertsRemoteDataSource {
  Stream<List<AlertModel>> streamActiveAlerts(String bikeId);
  Future<void> markAlertRead(String alertId);
}

@LazySingleton(as: IAlertsRemoteDataSource)
class AlertsRemoteDataSource implements IAlertsRemoteDataSource {
  AlertsRemoteDataSource(this._client)
    : _telemetryClient = SupabaseClient(
        AppConfig.supabaseUrl,
        AppConfig.supabasePublishableKey,
      );
  final SupabaseClient _client;
  final SupabaseClient _telemetryClient;

  @override
  Stream<List<AlertModel>> streamActiveAlerts(String bikeId) {
    final crashAlerts = _streamCrashAlerts(bikeId);
    if (_client.auth.currentSession == null) {
      return crashAlerts;
    }
    final storedAlerts = _client
        .from('alerts')
        .stream(primaryKey: ['id'])
        .eq('bike_id', bikeId)
        .order('created_at', ascending: false)
        .map(
          (rows) => rows
              .map((r) => AlertModel.fromJson(Map<String, dynamic>.from(r)))
              .where((a) => !a.isResolved)
              .toList(),
        );
    return Rx.combineLatest2(storedAlerts, crashAlerts, (
      List<AlertModel> stored,
      List<AlertModel> crashes,
    ) {
      final combined = [...crashes, ...stored];
      combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return combined;
    });
  }

  Stream<List<AlertModel>> _streamCrashAlerts(String bikeId) {
    final deviceId = AppConfig.mqttBikeId;
    if (deviceId.isEmpty) return Stream.value([]);

    return Stream<void>.periodic(
      const Duration(seconds: 20),
    ).startWith(null).asyncMap((_) async {
      final rows = await _telemetryClient
          .from('ebike_telemetry')
          .select('id,recorded_at,accel_x,accel_y,accel_z,gyro_x,gyro_y,gyro_z')
          .eq('device_id', deviceId)
          // Query a deliberately wider component threshold. Any vector whose
          // magnitude can satisfy the crash detector must have at least one
          // component above magnitude / sqrt(3). This lets Supabase return
          // historical candidates without yesterday's event being pushed out
          // by thousands of ordinary telemetry rows.
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
      final events = CrashAnalysisService.analyze(
        (rows as List)
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList(),
      );
      return events.take(50).map((event) {
        return AlertModel(
          id: event.id,
          bikeId: bikeId,
          severity: event.isCritical ? 'critical' : 'warning',
          type: 'crash',
          title: event.isCritical
              ? 'Severe crash detected'
              : 'Crash sequence detected',
          message:
              '${event.phaseSummary}. Peak impact ${event.peakImpactG.toStringAsFixed(1)} g, rotation ${event.peakRotationDps.toStringAsFixed(0)}°/s.',
          // Historical crash events are reconstructed from telemetry rather
          // than persisted in the alerts table.
          isRead: true,
          isResolved: false,
          createdAt: event.detectedAt.toIso8601String(),
        );
      }).toList();
    });
  }

  @override
  Future<void> markAlertRead(String alertId) async {
    if (alertId.startsWith('crash-') || alertId.startsWith('mqtt-crash-')) {
      return;
    }
    try {
      await _client.from('alerts').update({'is_read': true}).eq('id', alertId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
