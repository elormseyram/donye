// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => _AlertModel(
  id: json['id'] as String,
  bikeId: json['bike_id'] as String,
  severity: json['severity'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  isRead: json['is_read'] as bool? ?? false,
  isResolved: json['is_resolved'] as bool? ?? false,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$AlertModelToJson(_AlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bike_id': instance.bikeId,
      'severity': instance.severity,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'is_resolved': instance.isResolved,
      'created_at': instance.createdAt,
    };
