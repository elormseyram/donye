import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_entity.freezed.dart';

@freezed
abstract class AppSettingsEntity with _$AppSettingsEntity {
  const factory AppSettingsEntity({
    @Default(true) bool notificationsEnabled,
    @Default(true) bool mqttAlertSounds,
    @Default(true) bool locationSharing,
    @Default('standard') String mapStyle,
    @Default(1000) int telemetryRefreshRateMs,
    @Default(false) bool biometricAuthEnabled,
  }) = _AppSettingsEntity;
}
