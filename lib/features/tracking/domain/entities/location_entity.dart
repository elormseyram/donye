import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_entity.freezed.dart';

@freezed
abstract class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required String bikeId,
    required double latitude,
    required double longitude,
    required double headingDegrees,
    required double speedKmh,
    required double accuracyM,
    required DateTime timestamp,
  }) = _LocationEntity;
}
