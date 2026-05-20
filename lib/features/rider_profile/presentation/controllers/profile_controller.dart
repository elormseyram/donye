import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? avatarUrl,
  }) async {
    final rider = ref.read(currentRiderProvider).value;
    if (rider == null) return false;

    state = const AsyncValue.loading();
    final updated = rider.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl ?? rider.avatarUrl,
    );

    final useCase = ref.read(updateRiderProfileUseCaseProvider);
    final result = await useCase(updated);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(currentRiderProvider);
        return true;
      },
    );
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, AsyncValue<void>>(
  ProfileController.new,
);
