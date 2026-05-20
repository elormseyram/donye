// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TelemetryPayloadModel _$TelemetryPayloadModelFromJson(
  Map<String, dynamic> json,
) => _TelemetryPayloadModel(
  bikeId: json['bike_id'] as String,
  batteryPercentage: (json['battery_percentage'] as num).toDouble(),
  voltageV: (json['voltage_v'] as num).toDouble(),
  currentA: (json['current_a'] as num).toDouble(),
  speedKmh: (json['speed_kmh'] as num).toDouble(),
  temperatureCelsius: (json['temperature_celsius'] as num).toDouble(),
  odometer: (json['odometer'] as num).toDouble(),
  motorRpm: (json['motor_rpm'] as num).toInt(),
  status: json['status'] as String,
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$TelemetryPayloadModelToJson(
  _TelemetryPayloadModel instance,
) => <String, dynamic>{
  'bike_id': instance.bikeId,
  'battery_percentage': instance.batteryPercentage,
  'voltage_v': instance.voltageV,
  'current_a': instance.currentA,
  'speed_kmh': instance.speedKmh,
  'temperature_celsius': instance.temperatureCelsius,
  'odometer': instance.odometer,
  'motor_rpm': instance.motorRpm,
  'status': instance.status,
  'timestamp': instance.timestamp,
};
