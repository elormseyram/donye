import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../domain/entities/rider_entity.dart';
import '../../domain/interfaces/i_auth_repository.dart';
import '../../domain/usecases/get_current_rider_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => getIt<IAuthRepository>(),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => getIt<LoginUseCase>(),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => getIt<LogoutUseCase>(),
);

final signupUseCaseProvider = Provider<SignupUseCase>(
  (ref) => getIt<SignupUseCase>(),
);

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>(
  (ref) => getIt<ForgotPasswordUseCase>(),
);

final getCurrentRiderUseCaseProvider = Provider<GetCurrentRiderUseCase>(
  (ref) => getIt<GetCurrentRiderUseCase>(),
);

/// Streams whether the user is authenticated (true/false).
final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).authStateStream;
});

/// Fetches and caches the current rider profile.
final currentRiderProvider = FutureProvider<RiderEntity?>((ref) async {
  final isAuth = await ref.watch(authStateProvider.future);
  if (!isAuth) return null;
  final useCase = ref.watch(getCurrentRiderUseCaseProvider);
  final result = await useCase();
  return result.fold((_) => null, (rider) => rider);
});

/// Derived: the assigned bike ID of the current rider.
final assignedBikeIdProvider = Provider<String?>((ref) {
  return ref.watch(currentRiderProvider).valueOrNull?.assignedBikeId;
});
