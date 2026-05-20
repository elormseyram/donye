// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RideSessionModel _$RideSessionModelFromJson(Map<String, dynamic> json) =>
    _RideSessionModel(
      id: json['id'] as String,
      riderId: json['rider_id'] as String,
      bikeId: json['bike_id'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      avgSpeedKmh: (json['avg_speed_kmh'] as num?)?.toDouble() ?? 0.0,
      maxSpeedKmh: (json['max_speed_kmh'] as num?)?.toDouble() ?? 0.0,
      energyConsumedKwh:
          (json['energy_consumed_kwh'] as num?)?.toDouble() ?? 0.0,
      avgBatteryDrain: (json['avg_battery_drain'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$RideSessionModelToJson(_RideSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rider_id': instance.riderId,
      'bike_id': instance.bikeId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'distance_km': instance.distanceKm,
      'avg_speed_kmh': instance.avgSpeedKmh,
      'max_speed_kmh': instance.maxSpeedKmh,
      'energy_consumed_kwh': instance.energyConsumedKwh,
      'avg_battery_drain': instance.avgBatteryDrain,
    };
