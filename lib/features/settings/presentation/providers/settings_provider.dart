import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/interfaces/i_settings_repository.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';

final settingsRepositoryProvider = Provider<ISettingsRepository>(
  (ref) => getIt<ISettingsRepository>(),
);

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>(
  (ref) => getIt<GetSettingsUseCase>(),
);

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>(
  (ref) => getIt<UpdateSettingsUseCase>(),
);

class AppSettingsNotifier extends Notifier<AppSettingsEntity> {
  @override
  AppSettingsEntity build() {
    final useCase = ref.read(getSettingsUseCaseProvider);
    return useCase().fold((_) => const AppSettingsEntity(), (s) => s);
  }

  Future<void> update(AppSettingsEntity settings) async {
    final useCase = ref.read(updateSettingsUseCaseProvider);
    await useCase(settings);
    state = settings;
  }

  Future<void> toggle({
    bool? notificationsEnabled,
    bool? mqttAlertSounds,
    bool? locationSharing,
    bool? biometricAuthEnabled,
    String? mapStyle,
    int? telemetryRefreshRateMs,
  }) async {
    await update(state.copyWith(
      notificationsEnabled: notificationsEnabled ?? state.notificationsEnabled,
      mqttAlertSounds: mqttAlertSounds ?? state.mqttAlertSounds,
      locationSharing: locationSharing ?? state.locationSharing,
      biometricAuthEnabled: biometricAuthEnabled ?? state.biometricAuthEnabled,
      mapStyle: mapStyle ?? state.mapStyle,
      telemetryRefreshRateMs:
          telemetryRefreshRateMs ?? state.telemetryRefreshRateMs,
    ));
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsEntity>(
  AppSettingsNotifier.new,
);
