import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/command_type.dart';
import '../../../../shared/enums/command_status.dart';
import '../../domain/entities/bike_command_entity.dart';

part 'bike_command_model.freezed.dart';
part 'bike_command_model.g.dart';

@freezed
abstract class BikeCommandModel with _$BikeCommandModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BikeCommandModel({
    required String bikeId,
    required String type,
    String? payload,
    required String issuedAt,
    required String status,
  }) = _BikeCommandModel;

  factory BikeCommandModel.fromJson(Map<String, dynamic> json) =>
      _$BikeCommandModelFromJson(json);
}

extension BikeCommandModelX on BikeCommandModel {
  BikeCommandEntity toEntity() => BikeCommandEntity(
        bikeId: bikeId,
        type: CommandType.values.firstWhere(
          (t) => t.name == type,
          orElse: () => CommandType.lock,
        ),
        payload: payload,
        issuedAt: DateTime.parse(issuedAt),
        status: CommandStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => CommandStatus.pending,
        ),
      );

  Map<String, dynamic> toMqttPayload() => {
        'bike_id': bikeId,
        'type': type,
        if (payload != null) 'payload': payload,
        'issued_at': issuedAt,
      };
}
