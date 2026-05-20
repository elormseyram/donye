import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/fault_severity.dart';

part 'fault_code.freezed.dart';

@freezed
abstract class FaultCode with _$FaultCode {
  const factory FaultCode({
    required String code,
    required String description,
    required FaultSeverity severity,
    required DateTime detectedAt,
    required bool isActive,
  }) = _FaultCode;
}
