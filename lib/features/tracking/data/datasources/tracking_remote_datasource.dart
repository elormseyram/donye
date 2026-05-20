import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      var query = _client
          .from('ride_locations')
          .select()
          .eq('bike_id', bikeId);

      if (since != null) {
        query = query.gte('timestamp', since.toIso8601String());
      }

      final rows = await query
          .order('timestamp', ascending: true)
          .limit(500);
      return (rows as List)
          .map((r) =>
              LocationPayloadModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
