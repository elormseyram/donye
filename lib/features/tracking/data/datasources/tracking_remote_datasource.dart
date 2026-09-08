import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/location_payload_model.dart';

abstract interface class ITrackingRemoteDataSource {
  Future<List<LocationPayloadModel>> getRideRoute(
    String bikeId, {
    DateTime? since,
  });
}

@LazySingleton(as: ITrackingRemoteDataSource)
class TrackingRemoteDataSource implements ITrackingRemoteDataSource {
  const TrackingRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<List<LocationPayloadModel>> getRideRoute(
    String bikeId, {
    DateTime? since,
  }) async {
    try {
      var query = _client.from('ride_locations').select().eq('bike_id', bikeId);

      if (since != null) {
        query = query.gte('timestamp', since.toIso8601String());
      }

      final rows = await query.order('timestamp', ascending: true).limit(500);
      final locations = (rows as List)
          .map((r) => LocationPayloadModel.fromJson(r as Map<String, dynamic>))
          .toList();
      if (locations.isNotEmpty) return locations;
      return _getFirmwareRoute(since);
    } catch (e) {
      try {
        return await _getFirmwareRoute(since);
      } catch (_) {
        throw ServerException(message: e.toString());
      }
    }
  }

  Future<List<LocationPayloadModel>> _getFirmwareRoute(DateTime? since) async {
    var query = _client
        .from('ebike_telemetry')
        .select('device_id,latitude,longitude,gps_speed,hdop,recorded_at')
        .eq('device_id', AppConfig.mqttBikeId)
        .neq('latitude', 0)
        .neq('longitude', 0);
    if (since != null) {
      query = query.gte('recorded_at', since.toIso8601String());
    }
    final rows = await query.order('recorded_at', ascending: true).limit(1000);
    return (rows as List).map((raw) {
      final row = Map<String, dynamic>.from(raw as Map);
      return LocationPayloadModel(
        bikeId: '${row['device_id'] ?? AppConfig.mqttBikeId}',
        latitude: _number(row['latitude']),
        longitude: _number(row['longitude']),
        headingDegrees: 0,
        speedKmh: _number(row['gps_speed']),
        accuracyM: _number(row['hdop']) * 5,
        timestamp: '${row['recorded_at'] ?? DateTime.now().toIso8601String()}',
      );
    }).toList();
  }

  double _number(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
