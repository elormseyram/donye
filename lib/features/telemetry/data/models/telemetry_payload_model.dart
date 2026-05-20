import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/telemetry_entity.dart';
import '../../../../shared/enums/telemetry_status.dart';

part 'telemetry_payload_model.freezed.dart';
part 'telemetry_payload_model.g.dart';

@freezed
abstract class TelemetryPayloadModel with _$TelemetryPayloadModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TelemetryPayloadModel({
    required String bikeId,
    required double batteryPercentage,
    required double voltageV,
    required double currentA,
    required double speedKmh,
    required double temperatureCelsius,
    required double odometer,
    required int motorRpm,
    required String status,
    required String timestamp,
  }) = _TelemetryPayloadModel;

  factory TelemetryPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$TelemetryPayloadModelFromJson(json);
}

extension TelemetryPayloadModelX on TelemetryPayloadModel {
  TelemetryEntity toEntity() => TelemetryEntity(
        bikeId: bikeId,
        batteryPercentage: batteryPercentage,
        voltageV: voltageV,
        currentA: currentA,
        speedKmh: speedKmh,
        temperatureCelsius: temperatureCelsius,
        odometer: odometer,
        motorRpm: motorRpm,
        status: TelemetryStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => TelemetryStatus.normal,
        ),
        timestamp: DateTime.parse(timestamp),
      );
}
