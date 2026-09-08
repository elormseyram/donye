import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../telemetry/presentation/providers/telemetry_provider.dart';
import '../../domain/interfaces/i_bike_control_repository.dart';
import '../../domain/usecases/send_command_usecase.dart';
import '../../domain/usecases/lock_bike_usecase.dart';
import '../../domain/usecases/unlock_bike_usecase.dart';

export '../../../auth/presentation/providers/auth_provider.dart'
    show assignedBikeIdProvider;

final bikeControlRepositoryProvider = Provider<IBikeControlRepository>(
  (ref) => getIt<IBikeControlRepository>(),
);

final sendCommandUseCaseProvider = Provider<SendCommandUseCase>(
  (ref) => getIt<SendCommandUseCase>(),
);

final lockBikeUseCaseProvider = Provider<LockBikeUseCase>(
  (ref) => getIt<LockBikeUseCase>(),
);

final unlockBikeUseCaseProvider = Provider<UnlockBikeUseCase>(
  (ref) => getIt<UnlockBikeUseCase>(),
);

final bikeSecurityStateProvider = StreamProvider<String>((ref) {
  return ref
      .watch(mqttServiceProvider)
      .bikeStatusStream
      .map((status) => '${status['security_state'] ?? 'unknown'}');
});
