// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceLogModel _$MaintenanceLogModelFromJson(Map<String, dynamic> json) =>
    _MaintenanceLogModel(
      id: json['id'] as String,
      bikeId: json['bike_id'] as String,
      description: json['description'] as String,
      performedAt: json['performed_at'] as String,
      nextDueAt: json['next_due_at'] as String?,
      technician: json['technician'] as String?,
    );

Map<String, dynamic> _$MaintenanceLogModelToJson(
  _MaintenanceLogModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'bike_id': instance.bikeId,
  'description': instance.description,
  'performed_at': instance.performedAt,
  'next_due_at': instance.nextDueAt,
  'technician': instance.technician,
};
