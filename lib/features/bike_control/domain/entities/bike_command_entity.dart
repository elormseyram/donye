import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/command_type.dart';
import '../../../../shared/enums/command_status.dart';

part 'bike_command_entity.freezed.dart';

@freezed
abstract class BikeCommandEntity with _$BikeCommandEntity {
  const factory BikeCommandEntity({
    required String bikeId,
    required CommandType type,
    String? payload,
    required DateTime issuedAt,
    required CommandStatus status,
  }) = _BikeCommandEntity;
}
