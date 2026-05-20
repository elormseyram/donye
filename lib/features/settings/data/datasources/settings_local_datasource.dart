import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/app_settings_entity.dart';

abstract class ISettingsLocalDataSource {
  AppSettingsEntity getSettings();
  Future<void> saveSettings(AppSettingsEntity settings);
}

@LazySingleton(as: ISettingsLocalDataSource)
class SettingsLocalDataSource implements ISettingsLocalDataSource {
  SettingsLocalDataSource(@Named('settingsBox') this._box);
  final Box _box;

  static const _key = 'app_settings';

  @override
  AppSettingsEntity getSettings() {
    final raw = _box.get(_key);
    if (raw == null) return const AppSettingsEntity();
    final map = Map<String, dynamic>.from(raw as Map);
    return AppSettingsEntity(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      mqttAlertSounds: map['mqttAlertSounds'] as bool? ?? true,
      locationSharing: map['locationSharing'] as bool? ?? true,
      mapStyle: map['mapStyle'] as String? ?? 'standard',
      telemetryRefreshRateMs: map['telemetryRefreshRateMs'] as int? ?? 1000,
      biometricAuthEnabled: map['biometricAuthEnabled'] as bool? ?? false,
    );
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    await _box.put(_key, {
      'notificationsEnabled': settings.notificationsEnabled,
      'mqttAlertSounds': settings.mqttAlertSounds,
      'locationSharing': settings.locationSharing,
      'mapStyle': settings.mapStyle,
      'telemetryRefreshRateMs': settings.telemetryRefreshRateMs,
      'biometricAuthEnabled': settings.biometricAuthEnabled,
    });
  }
}
