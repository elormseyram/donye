// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FaultCodeModel _$FaultCodeModelFromJson(Map<String, dynamic> json) =>
    _FaultCodeModel(
      code: json['code'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      detectedAt: json['detected_at'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$FaultCodeModelToJson(_FaultCodeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
      'severity': instance.severity,
      'detected_at': instance.detectedAt,
      'is_active': instance.isActive,
    };

_DiagnosticModel _$DiagnosticModelFromJson(Map<String, dynamic> json) =>
    _DiagnosticModel(
      id: json['id'] as String,
      bikeId: json['bike_id'] as String,
      healthScore: (json['health_score'] as num).toInt(),
      faultCodes: (json['fault_codes'] as List<dynamic>)
          .map((e) => FaultCodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastDiagnosticAt: json['last_diagnostic_at'] as String,
      maintenanceStatus: json['maintenance_status'] as String,
    );

Map<String, dynamic> _$DiagnosticModelToJson(_DiagnosticModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bike_id': instance.bikeId,
      'health_score': instance.healthScore,
      'fault_codes': instance.faultCodes,
      'last_diagnostic_at': instance.lastDiagnosticAt,
      'maintenance_status': instance.maintenanceStatus,
    };
