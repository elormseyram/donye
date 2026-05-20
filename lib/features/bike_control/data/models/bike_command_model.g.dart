// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike_command_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BikeCommandModel _$BikeCommandModelFromJson(Map<String, dynamic> json) =>
    _BikeCommandModel(
      bikeId: json['bike_id'] as String,
      type: json['type'] as String,
      payload: json['payload'] as String?,
      issuedAt: json['issued_at'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$BikeCommandModelToJson(_BikeCommandModel instance) =>
    <String, dynamic>{
      'bike_id': instance.bikeId,
      'type': instance.type,
      'payload': instance.payload,
      'issued_at': instance.issuedAt,
      'status': instance.status,
    };
