import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      return (rows as List)
          .map((r) => TelemetryPayloadModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
