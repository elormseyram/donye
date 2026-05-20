// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BikeModel _$BikeModelFromJson(Map<String, dynamic> json) => _BikeModel(
  id: json['id'] as String,
  serialNumber: json['serial_number'] as String,
  model: json['model'] as String,
  registrationNumber: json['registration_number'] as String,
  batteryCapacityKwh: (json['battery_capacity_kwh'] as num?)?.toDouble() ?? 0.0,
  lastServiceDate: json['last_service_date'] as String,
  status: json['status'] as String? ?? 'active',
);

Map<String, dynamic> _$BikeModelToJson(_BikeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serial_number': instance.serialNumber,
      'model': instance.model,
      'registration_number': instance.registrationNumber,
      'battery_capacity_kwh': instance.batteryCapacityKwh,
      'last_service_date': instance.lastServiceDate,
      'status': instance.status,
    };
