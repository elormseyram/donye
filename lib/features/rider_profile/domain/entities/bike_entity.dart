import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/bike_status.dart';

part 'bike_entity.freezed.dart';

@freezed
abstract class BikeEntity with _$BikeEntity {
  const factory BikeEntity({
    required String id,
    required String serialNumber,
    required String model,
    required String registrationNumber,
    required double batteryCapacityKwh,
    required DateTime lastServiceDate,
    required BikeStatus status,
  }) = _BikeEntity;
}
