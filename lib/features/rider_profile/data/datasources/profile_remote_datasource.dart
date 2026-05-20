import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/models/rider_model.dart';
import '../models/bike_model.dart';

abstract class IProfileRemoteDataSource {
  Future<BikeModel> getBike(String bikeId);
  Future<RiderModel> updateRider(Map<String, dynamic> data, String riderId);
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._client);
  final SupabaseClient _client;

  @override
  Future<BikeModel> getBike(String bikeId) async {
    try {
      final row = await _client
          .from('bikes')
          .select()
          .eq('id', bikeId)
          .single();
      return BikeModel.fromJson(Map<String, dynamic>.from(row));
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RiderModel> updateRider(
    Map<String, dynamic> data,
    String riderId,
  ) async {
    try {
      final row = await _client
          .from('riders')
          .update(data)
          .eq('id', riderId)
          .select()
          .single();
      return RiderModel.fromJson(Map<String, dynamic>.from(row));
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
