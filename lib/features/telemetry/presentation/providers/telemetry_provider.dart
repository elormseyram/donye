import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/mqtt_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/telemetry_entity.dart';
import '../../domain/interfaces/i_telemetry_repository.dart';
import '../../domain/usecases/get_telemetry_usecase.dart';
import '../../domain/usecases/get_telemetry_history_usecase.dart';

final mqttServiceProvider = Provider<MqttService>(
  (ref) => getIt<MqttService>(),
);

final telemetryRepositoryProvider = Provider<ITelemetryRepository>(
  (ref) => getIt<ITelemetryRepository>(),
);

final getTelemetryUseCaseProvider = Provider<GetTelemetryUseCase>(
  (ref) => getIt<GetTelemetryUseCase>(),
);

final getTelemetryHistoryUseCaseProvider =
    Provider<GetTelemetryHistoryUseCase>(
  (ref) => getIt<GetTelemetryHistoryUseCase>(),
);

/// Live stream of telemetry from MQTT.
final telemetryStreamProvider = StreamProvider<TelemetryEntity>((ref) {
  return ref.watch(getTelemetryUseCaseProvider).call();
});

/// Latest single telemetry snapshot (null until first MQTT message).
final latestTelemetryProvider = Provider<TelemetryEntity?>((ref) {
  return ref.watch(telemetryStreamProvider).valueOrNull;
});

final batteryProvider = Provider<double?>((ref) {
  return ref.watch(latestTelemetryProvider)?.batteryPercentage;
});

final speedProvider = Provider<double?>((ref) {
  return ref.watch(latestTelemetryProvider)?.speedKmh;
});

final voltageProvider = Provider<double?>((ref) {
  return ref.watch(latestTelemetryProvider)?.voltageV;
});

/// History from Supabase (fetched once per bikeId).
final telemetryHistoryProvider =
    FutureProvider<List<TelemetryEntity>>((ref) async {
  final bikeId = ref.watch(assignedBikeIdProvider);
  if (bikeId == null) return [];
  final useCase = ref.watch(getTelemetryHistoryUseCaseProvider);
  final result = await useCase(bikeId);
  return result.fold((_) => [], (list) => list);
});
