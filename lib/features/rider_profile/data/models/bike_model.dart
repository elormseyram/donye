import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/bike_status.dart';
import '../../domain/entities/bike_entity.dart';

part 'bike_model.freezed.dart';
part 'bike_model.g.dart';

@freezed
abstract class BikeModel with _$BikeModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BikeModel({
    required String id,
    required String serialNumber,
    required String model,
    required String registrationNumber,
    @Default(0.0) double batteryCapacityKwh,
    required String lastServiceDate,
    @Default('active') String status,
  }) = _BikeModel;

  factory BikeModel.fromJson(Map<String, dynamic> json) =>
      _$BikeModelFromJson(json);
}

extension BikeModelX on BikeModel {
  BikeEntity toEntity() => BikeEntity(
        id: id,
        serialNumber: serialNumber,
        model: model,
        registrationNumber: registrationNumber,
        batteryCapacityKwh: batteryCapacityKwh,
        lastServiceDate:
            DateTime.tryParse(lastServiceDate) ?? DateTime(2000),
        status: _parseStatus(status),
      );

  BikeStatus _parseStatus(String s) => switch (s) {
        'maintenance' => BikeStatus.maintenance,
        'inactive' => BikeStatus.inactive,
        _ => BikeStatus.active,
      };
}
