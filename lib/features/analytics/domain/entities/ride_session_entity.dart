import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride_session_entity.freezed.dart';

@freezed
abstract class RideSessionEntity with _$RideSessionEntity {
  const factory RideSessionEntity({
    required String id,
    required String riderId,
    required String bikeId,
    required DateTime startTime,
    DateTime? endTime,
    required double distanceKm,
    required double avgSpeedKmh,
    required double maxSpeedKmh,
    required double energyConsumedKwh,
    required double avgBatteryDrain,
  }) = _RideSessionEntity;
}
