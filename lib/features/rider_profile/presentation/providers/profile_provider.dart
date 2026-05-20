import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/bike_entity.dart';
import '../../domain/interfaces/i_profile_repository.dart';
import '../../domain/usecases/get_assigned_bike_usecase.dart';
import '../../domain/usecases/update_rider_profile_usecase.dart';

final profileRepositoryProvider = Provider<IProfileRepository>(
  (ref) => getIt<IProfileRepository>(),
);

final getAssignedBikeUseCaseProvider = Provider<GetAssignedBikeUseCase>(
  (ref) => getIt<GetAssignedBikeUseCase>(),
);

final updateRiderProfileUseCaseProvider = Provider<UpdateRiderProfileUseCase>(
  (ref) => getIt<UpdateRiderProfileUseCase>(),
);

final currentBikeProvider = FutureProvider<BikeEntity?>((ref) async {
  final bikeId = ref.watch(assignedBikeIdProvider);
  if (bikeId == null) return null;
  final useCase = ref.watch(getAssignedBikeUseCaseProvider);
  final result = await useCase(bikeId);
  return result.fold((_) => null, (bike) => bike);
});
