import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/maintenance_status.dart';
import '../../../../shared/enums/fault_severity.dart';
import '../../domain/entities/diagnostic_entity.dart';
import '../../domain/entities/fault_code.dart';

part 'diagnostic_model.freezed.dart';
part 'diagnostic_model.g.dart';

@freezed
abstract class FaultCodeModel with _$FaultCodeModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FaultCodeModel({
    required String code,
    required String description,
    required String severity,
    required String detectedAt,
    required bool isActive,
  }) = _FaultCodeModel;

  factory FaultCodeModel.fromJson(Map<String, dynamic> json) =>
      _$FaultCodeModelFromJson(json);
}

@freezed
abstract class DiagnosticModel with _$DiagnosticModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DiagnosticModel({
    required String id,
    required String bikeId,
    required int healthScore,
    required List<FaultCodeModel> faultCodes,
    required String lastDiagnosticAt,
    required String maintenanceStatus,
  }) = _DiagnosticModel;

  factory DiagnosticModel.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticModelFromJson(json);
}

extension FaultCodeModelX on FaultCodeModel {
  FaultCode toEntity() => FaultCode(
        code: code,
        description: description,
        severity: FaultSeverity.values.firstWhere(
          (s) => s.name == severity,
          orElse: () => FaultSeverity.minor,
        ),
        detectedAt: DateTime.parse(detectedAt),
        isActive: isActive,
      );
}

extension DiagnosticModelX on DiagnosticModel {
  DiagnosticEntity toEntity() => DiagnosticEntity(
        id: id,
        bikeId: bikeId,
        healthScore: healthScore,
        faultCodes: faultCodes.map((f) => f.toEntity()).toList(),
        lastDiagnosticAt: DateTime.parse(lastDiagnosticAt),
        maintenanceStatus: MaintenanceStatus.values.firstWhere(
          (s) => s.name == maintenanceStatus,
          orElse: () => MaintenanceStatus.ok,
        ),
      );
}
