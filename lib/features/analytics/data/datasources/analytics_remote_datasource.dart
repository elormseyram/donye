import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/ride_session_model.dart';

abstract class IAnalyticsRemoteDataSource {
  Future<List<RideSessionModel>> getRideSessions(String riderId);
}

@LazySingleton(as: IAnalyticsRemoteDataSource)
class AnalyticsRemoteDataSource implements IAnalyticsRemoteDataSource {
  const AnalyticsRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<List<RideSessionModel>> getRideSessions(String riderId) async {
    try {
      final rows = await _client
          .from('ride_sessions')
          .select()
          .eq('rider_id', riderId)
          .order('start_time', ascending: false)
          .limit(50);

      return (rows as List)
          .map((r) => RideSessionModel.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
