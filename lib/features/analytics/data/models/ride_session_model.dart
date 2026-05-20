import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ride_session_entity.dart';

part 'ride_session_model.freezed.dart';
part 'ride_session_model.g.dart';

@freezed
abstract class RideSessionModel with _$RideSessionModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RideSessionModel({
    required String id,
    required String riderId,
    required String bikeId,
    required String startTime,
    String? endTime,
    @Default(0.0) double distanceKm,
    @Default(0.0) double avgSpeedKmh,
    @Default(0.0) double maxSpeedKmh,
    @Default(0.0) double energyConsumedKwh,
    @Default(0.0) double avgBatteryDrain,
  }) = _RideSessionModel;

  factory RideSessionModel.fromJson(Map<String, dynamic> json) =>
      _$RideSessionModelFromJson(json);
}

extension RideSessionModelX on RideSessionModel {
  RideSessionEntity toEntity() => RideSessionEntity(
        id: id,
        riderId: riderId,
        bikeId: bikeId,
        startTime: DateTime.parse(startTime),
        endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
        distanceKm: distanceKm,
        avgSpeedKmh: avgSpeedKmh,
        maxSpeedKmh: maxSpeedKmh,
        energyConsumedKwh: energyConsumedKwh,
        avgBatteryDrain: avgBatteryDrain,
      );
}
