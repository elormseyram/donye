import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_log_model.freezed.dart';
part 'maintenance_log_model.g.dart';

@freezed
abstract class MaintenanceLogModel with _$MaintenanceLogModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MaintenanceLogModel({
    required String id,
    required String bikeId,
    required String description,
    required String performedAt,
    String? nextDueAt,
    String? technician,
  }) = _MaintenanceLogModel;

  factory MaintenanceLogModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceLogModelFromJson(json);
}
