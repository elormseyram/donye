import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/alert_severity.dart';
import '../../../../shared/enums/alert_type.dart';

part 'alert_entity.freezed.dart';

@freezed
abstract class AlertEntity with _$AlertEntity {
  const factory AlertEntity({
    required String id,
    required String bikeId,
    required AlertSeverity severity,
    required AlertType type,
    required String title,
    required String message,
    required bool isRead,
    required bool isResolved,
    required DateTime createdAt,
  }) = _AlertEntity;
}
