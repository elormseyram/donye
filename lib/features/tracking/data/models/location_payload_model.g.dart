// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationPayloadModel _$LocationPayloadModelFromJson(
  Map<String, dynamic> json,
) => _LocationPayloadModel(
  bikeId: json['bike_id'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  headingDegrees: (json['heading_degrees'] as num).toDouble(),
  speedKmh: (json['speed_kmh'] as num).toDouble(),
  accuracyM: (json['accuracy_m'] as num).toDouble(),
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$LocationPayloadModelToJson(
  _LocationPayloadModel instance,
) => <String, dynamic>{
  'bike_id': instance.bikeId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'heading_degrees': instance.headingDegrees,
  'speed_kmh': instance.speedKmh,
  'accuracy_m': instance.accuracyM,
  'timestamp': instance.timestamp,
};
