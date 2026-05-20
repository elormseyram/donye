import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/rider_entity.dart';

part 'rider_model.freezed.dart';
part 'rider_model.g.dart';

@freezed
abstract class RiderModel with _$RiderModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RiderModel({
    required String id,
    required String email,
    required String fullName,
    required String phoneNumber,
    String? avatarUrl,
    String? assignedBikeId,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _RiderModel;

  factory RiderModel.fromJson(Map<String, dynamic> json) =>
      _$RiderModelFromJson(json);
}

extension RiderModelX on RiderModel {
  RiderEntity toEntity() => RiderEntity(
        id: id,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
        assignedBikeId: assignedBikeId,
        createdAt: createdAt,
        isActive: isActive,
      );
}
