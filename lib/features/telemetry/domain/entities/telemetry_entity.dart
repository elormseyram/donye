import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/telemetry_status.dart';

part 'telemetry_entity.freezed.dart';

@freezed
abstract class TelemetryEntity with _$TelemetryEntity {
  const factory TelemetryEntity({
    required String bikeId,
    required double batteryPercentage,
    required double voltageV,
    required double currentA,
    required double speedKmh,
    required double temperatureCelsius,
    required double odometer,
    required int motorRpm,
    required TelemetryStatus status,
    required DateTime timestamp,
  }) = _TelemetryEntity;
}
