import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/ride_session_entity.dart';
import '../../domain/entities/weekly_stats_entity.dart';
import '../../domain/interfaces/i_analytics_repository.dart';
import '../../domain/usecases/get_ride_sessions_usecase.dart';
import '../../domain/usecases/get_weekly_stats_usecase.dart';

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>(
  (ref) => getIt<IAnalyticsRepository>(),
);

final getRideSessionsUseCaseProvider = Provider<GetRideSessionsUseCase>(
  (ref) => getIt<GetRideSessionsUseCase>(),
);

final getWeeklyStatsUseCaseProvider = Provider<GetWeeklyStatsUseCase>(
  (ref) => getIt<GetWeeklyStatsUseCase>(),
);

final rideSessionsProvider =
    FutureProvider.autoDispose<List<RideSessionEntity>>((ref) async {
      final riderId = ref.watch(currentRiderProvider).value?.id;
      if (riderId == null) return [];
      final useCase = ref.watch(getRideSessionsUseCaseProvider);
      final result = await useCase(riderId);
      return result.fold(
        (failure) => throw StateError(failure.message),
        (sessions) => sessions,
      );
    });

final weeklyStatsProvider = FutureProvider.autoDispose<WeeklyStatsEntity?>((
  ref,
) async {
  final riderId = ref.watch(currentRiderProvider).value?.id;
  if (riderId == null) return null;
  final useCase = ref.watch(getWeeklyStatsUseCaseProvider);
  final result = await useCase(riderId);
  return result.fold(
    (failure) => throw StateError(failure.message),
    (stats) => stats,
  );
});
