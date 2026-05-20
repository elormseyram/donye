import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/alert_severity.dart';
import '../../../../shared/enums/alert_type.dart';
import '../../domain/entities/alert_entity.dart';

part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

@freezed
abstract class AlertModel with _$AlertModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AlertModel({
    required String id,
    required String bikeId,
    required String severity,
    required String type,
    required String title,
    required String message,
    @Default(false) bool isRead,
    @Default(false) bool isResolved,
    required String createdAt,
  }) = _AlertModel;

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);
}

extension AlertModelX on AlertModel {
  AlertEntity toEntity() => AlertEntity(
        id: id,
        bikeId: bikeId,
        severity: _parseSeverity(severity),
        type: _parseType(type),
        title: title,
        message: message,
        isRead: isRead,
        isResolved: isResolved,
        createdAt: DateTime.parse(createdAt),
      );

  AlertSeverity _parseSeverity(String s) => switch (s) {
        'warning' => AlertSeverity.warning,
        'critical' => AlertSeverity.critical,
        _ => AlertSeverity.info,
      };

  AlertType _parseType(String t) => switch (t) {
        'battery_low' => AlertType.batteryLow,
        'overheat' => AlertType.overheat,
        'geofence' => AlertType.geofence,
        'tamper' => AlertType.tamper,
        _ => AlertType.fault,
      };
}
