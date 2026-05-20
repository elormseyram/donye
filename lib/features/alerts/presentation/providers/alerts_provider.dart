import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/interfaces/i_alerts_repository.dart';
import '../../domain/usecases/mark_alert_read_usecase.dart';
import '../../domain/usecases/stream_active_alerts_usecase.dart';

final alertsRepositoryProvider = Provider<IAlertsRepository>(
  (ref) => getIt<IAlertsRepository>(),
);

final streamActiveAlertsUseCaseProvider =
    Provider<StreamActiveAlertsUseCase>(
  (ref) => getIt<StreamActiveAlertsUseCase>(),
);

final markAlertReadUseCaseProvider = Provider<MarkAlertReadUseCase>(
  (ref) => getIt<MarkAlertReadUseCase>(),
);

final activeAlertsProvider = StreamProvider<List<AlertEntity>>((ref) {
  final bikeId = ref.watch(assignedBikeIdProvider);
  if (bikeId == null) return const Stream.empty();
  final useCase = ref.watch(streamActiveAlertsUseCaseProvider);
  return useCase(bikeId);
});

final unreadAlertCountProvider = Provider<int>((ref) {
  return ref.watch(activeAlertsProvider).value
          ?.where((a) => !a.isRead)
          .length ??
      0;
});
