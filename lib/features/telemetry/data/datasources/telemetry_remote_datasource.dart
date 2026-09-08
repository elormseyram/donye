import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/telemetry_payload_model.dart';

abstract interface class ITelemetryRemoteDataSource {
  Future<List<TelemetryPayloadModel>> getHistory(
    String bikeId, {
    int limit = 100,
  });
}

@LazySingleton(as: ITelemetryRemoteDataSource)
class TelemetryRemoteDataSource implements ITelemetryRemoteDataSource {
  const TelemetryRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<List<TelemetryPayloadModel>> getHistory(
    String bikeId, {
    int limit = 100,
  }) async {
    try {
      final rows = await _client
          .from('telemetry_logs')
          .select()
          .eq('bike_id', bikeId)
          .order('timestamp', ascending: false)
          .limit(limit);
      final history = (rows as List)
          .map((r) => TelemetryPayloadModel.fromJson(r as Map<String, dynamic>))
          .toList();
      if (history.isNotEmpty) return history;
      return _getFirmwareHistory(limit);
    } catch (e) {
      try {
        return await _getFirmwareHistory(limit);
      } catch (_) {
        throw ServerException(message: e.toString());
      }
    }
  }

  Future<List<TelemetryPayloadModel>> _getFirmwareHistory(int limit) async {
    final rows = await _client
        .from('ebike_telemetry')
        .select('device_id,gps_speed,recorded_at')
        .eq('device_id', AppConfig.mqttBikeId)
        .order('recorded_at', ascending: false)
        .limit(limit);

    return (rows as List).map((raw) {
      final row = Map<String, dynamic>.from(raw as Map);
      return TelemetryPayloadModel(
        bikeId: '${row['device_id'] ?? AppConfig.mqttBikeId}',
        batteryPercentage: 0,
        voltageV: 0,
        currentA: 0,
        speedKmh: _number(row['gps_speed']),
        temperatureCelsius: 0,
        odometer: 0,
        motorRpm: 0,
        status: 'normal',
        timestamp: '${row['recorded_at'] ?? DateTime.now().toIso8601String()}',
      );
    }).toList();
  }

  double _number(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
