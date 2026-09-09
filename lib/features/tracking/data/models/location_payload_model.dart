import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_payload_model.freezed.dart';
part 'location_payload_model.g.dart';

@freezed
abstract class LocationPayloadModel with _$LocationPayloadModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LocationPayloadModel({
    required String bikeId,
    required double latitude,
    required double longitude,
    required double headingDegrees,
    required double speedKmh,
    required double accuracyM,
    required String timestamp,
  }) = _LocationPayloadModel;

  factory LocationPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$LocationPayloadModelFromJson(json);
}

extension LocationPayloadModelX on LocationPayloadModel {
  LocationEntity toEntity() => LocationEntity(
    bikeId: bikeId,
    latitude: latitude,
    longitude: longitude,
    headingDegrees: headingDegrees,
    speedKmh: speedKmh,
    accuracyM: accuracyM,
    timestamp: DateTime.parse(timestamp),
  );
}
