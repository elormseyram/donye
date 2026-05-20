// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiderModel _$RiderModelFromJson(Map<String, dynamic> json) => _RiderModel(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String,
  phoneNumber: json['phone_number'] as String,
  avatarUrl: json['avatar_url'] as String?,
  assignedBikeId: json['assigned_bike_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$RiderModelToJson(_RiderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'phone_number': instance.phoneNumber,
      'avatar_url': instance.avatarUrl,
      'assigned_bike_id': instance.assignedBikeId,
      'created_at': instance.createdAt.toIso8601String(),
      'is_active': instance.isActive,
    };
