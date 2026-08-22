import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/models/rider_model.dart';
import '../../../auth/data/datasources/portal_session_cache.dart';
import '../models/bike_model.dart';

abstract class IProfileRemoteDataSource {
  Future<BikeModel> getBike(String bikeId);
  Future<BikeModel> updateBatteryCapacity(String bikeId, double capacityKwh);
  Future<RiderModel> updateRider(Map<String, dynamic> data, String riderId);
}

@LazySingleton(as: IProfileRemoteDataSource)
class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client)
      : _portalClient = SupabaseClient(
          AppConfig.dornyePortalUrl,
          AppConfig.dornyePortalPublishableKey,
        );
  final SupabaseClient _client;
  final SupabaseClient _portalClient;

  @override
  Future<BikeModel> getBike(String bikeId) async {
    final portalBike = PortalSessionCache.bike;
    if (portalBike != null) {
      return BikeModel(
        id: bikeId,
        serialNumber: (portalBike['serial_number'] ??
                portalBike['serialNumber'] ??
                portalBike['asset_tag'] ??
                portalBike['assetTag'] ??
                portalBike['bike_number'] ??
                portalBike['bikeNumber'] ??
                portalBike['code'] ??
                '')
            .toString(),
        model: (portalBike['model'] ?? portalBike['bike_model'] ?? 'Electric bike')
            .toString(),
        registrationNumber: (portalBike['registration_number'] ??
                portalBike['registrationNumber'] ??
                portalBike['registration'] ??
                portalBike['plate_number'] ??
                '')
            .toString(),
        batteryCapacityKwh: double.tryParse(
              (portalBike['battery_capacity_kwh'] ??
                      portalBike['batteryCapacityKwh'] ??
                      0)
                  .toString(),
            ) ??
            0,
        lastServiceDate: (portalBike['last_service_date'] ??
                portalBike['lastServiceDate'] ??
                DateTime.now().toIso8601String())
            .toString(),
        status: (portalBike['status'] ?? 'active').toString(),
      );
    }
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
  Future<BikeModel> updateBatteryCapacity(
    String bikeId,
    double capacityKwh,
  ) async {
    try {
      final token = PortalSessionCache.sessionToken;
      if (token != null) {
        final response = await _portalClient.functions.invoke(
          'rider-portal',
          body: {
            'action': 'update_bike_battery',
            'riderId': PortalSessionCache.riderId,
            'email': PortalSessionCache.riderEmail,
            'sessionToken': token,
            'batteryCapacityKwh': capacityKwh,
          },
        );
        final envelope = response.data;
        final data = envelope is Map && envelope['ok'] == true
            ? envelope['data']
            : null;
        final bike = data is Map ? data['bike'] : null;
        if (bike is! Map) {
          throw ServerException(
            message: envelope is Map
                ? envelope['error']?.toString() ?? 'Could not update battery capacity'
                : 'Could not update battery capacity',
          );
        }
        PortalSessionCache.bike = Map<String, dynamic>.from(bike);
        return getBike(bikeId);
      }

      final row = await _client
          .from('bikes')
          .update({'battery_capacity_kwh': capacityKwh})
          .eq('id', bikeId)
          .select()
          .single();
      return BikeModel.fromJson(Map<String, dynamic>.from(row));
    } on ServerException {
      rethrow;
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
