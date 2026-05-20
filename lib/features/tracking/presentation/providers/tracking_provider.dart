import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/interfaces/i_tracking_repository.dart';
import '../../domain/usecases/stream_live_location_usecase.dart';
import '../../domain/usecases/get_ride_route_usecase.dart';

final trackingRepositoryProvider = Provider<ITrackingRepository>(
  (ref) => getIt<ITrackingRepository>(),
);

final streamLiveLocationUseCaseProvider =
    Provider<StreamLiveLocationUseCase>(
  (ref) => getIt<StreamLiveLocationUseCase>(),
);

final getRideRouteUseCaseProvider = Provider<GetRideRouteUseCase>(
  (ref) => getIt<GetRideRouteUseCase>(),
);

/// Live location stream from MQTT.
final liveLocationProvider = StreamProvider<LocationEntity>((ref) {
  return ref.watch(streamLiveLocationUseCaseProvider).call();
});

/// Latest single location snapshot.
final currentLocationProvider = Provider<LocationEntity?>((ref) {
  return ref.watch(liveLocationProvider).valueOrNull;
});

/// Route history fetched from Supabase for the current session.
final rideRouteProvider =
    FutureProvider<List<LocationEntity>>((ref) async {
  final bikeId = ref.watch(assignedBikeIdProvider);
  if (bikeId == null) return [];
  final useCase = ref.watch(getRideRouteUseCaseProvider);
  final result = await useCase(
    bikeId,
    since: DateTime.now().subtract(const Duration(hours: 8)),
  );
  return result.fold((_) => [], (list) => list);
});
