import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/alert_model.dart';

abstract class IAlertsRemoteDataSource {
  Stream<List<AlertModel>> streamActiveAlerts(String bikeId);
  Future<void> markAlertRead(String alertId);
}

@LazySingleton(as: IAlertsRemoteDataSource)
class AlertsRemoteDataSource implements IAlertsRemoteDataSource {
  const AlertsRemoteDataSource(this._client);
  final SupabaseClient _client;

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
        .map((rows) => rows
            .map((r) => AlertModel.fromJson(Map<String, dynamic>.from(r)))
            .where((a) => !a.isResolved)
            .toList());
    return Rx.combineLatest2(
      storedAlerts,
      crashAlerts,
      (List<AlertModel> stored, List<AlertModel> crashes) {
        final combined = [...crashes, ...stored];
        combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return combined;
      },
    );
  }

  Stream<List<AlertModel>> _streamCrashAlerts(String bikeId) {
    final deviceId = AppConfig.mqttBikeId;
    if (deviceId.isEmpty) return Stream.value([]);

    return _client
        .from('ebike_telemetry')
        .stream(primaryKey: ['id'])
        .eq('device_id', deviceId)
        .order('recorded_at', ascending: false)
        .map((rows) {
          return rows
              .map((row) {
                final x = _number(row['accel_x']);
                final y = _number(row['accel_y']);
                final z = _number(row['accel_z']);
                final impact = math.sqrt(x * x + y * y + z * z);
                if (impact < 3.0) return null;
                final recordedAt = row['recorded_at']?.toString() ??
                    DateTime.now().toIso8601String();
                return AlertModel(
                  id: 'crash-${row['id']}',
                  bikeId: bikeId,
                  severity: impact >= 5.0 ? 'critical' : 'warning',
                  type: 'crash',
                  title: impact >= 5.0
                      ? 'Severe crash detected'
                      : 'Possible crash detected',
                  message:
                      'Impact of ${impact.toStringAsFixed(1)} g was detected by the bike.',
                  isRead: true,
                  isResolved: false,
                  createdAt: recordedAt,
                );
              })
              .whereType<AlertModel>()
              .take(50)
              .toList();
        });
  }

  double _number(Object? value) => double.tryParse('$value') ?? 0.0;

  @override
  Future<void> markAlertRead(String alertId) async {
    try {
      await _client
          .from('alerts')
          .update({'is_read': true}).eq('id', alertId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
