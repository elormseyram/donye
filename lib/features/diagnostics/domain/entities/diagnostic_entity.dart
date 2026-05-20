import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/maintenance_status.dart';
import 'fault_code.dart';

part 'diagnostic_entity.freezed.dart';

@freezed
abstract class DiagnosticEntity with _$DiagnosticEntity {
  const factory DiagnosticEntity({
    required String id,
    required String bikeId,
    required int healthScore,
    required List<FaultCode> faultCodes,
    required DateTime lastDiagnosticAt,
    required MaintenanceStatus maintenanceStatus,
  }) = _DiagnosticEntity;
}
