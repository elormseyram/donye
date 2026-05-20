import 'package:freezed_annotation/freezed_annotation.dart';

part 'rider_entity.freezed.dart';

@freezed
abstract class RiderEntity with _$RiderEntity {
  const factory RiderEntity({
    required String id,
    required String email,
    required String fullName,
    required String phoneNumber,
    String? avatarUrl,
    String? assignedBikeId,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _RiderEntity;
}
