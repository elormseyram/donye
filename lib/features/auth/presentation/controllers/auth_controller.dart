import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/rider_entity.dart';
import '../providers/auth_provider.dart';
import '../../../telemetry/presentation/providers/telemetry_provider.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.rider,
    this.errorMessage,
  });

  final AuthStatus status;
  final RiderEntity? rider;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    RiderEntity? rider,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        rider: rider ?? this.rider,
        errorMessage: errorMessage,
      );
}

class AuthController extends AutoDisposeNotifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(email: email, password: password);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (rider) {
        state = state.copyWith(status: AuthStatus.authenticated, rider: rider);
        _connectMqtt(rider);
        return true;
      },
    );
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final useCase = ref.read(signupUseCaseProvider);
    final result = await useCase(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (rider) {
        state = state.copyWith(status: AuthStatus.authenticated, rider: rider);
        _connectMqtt(rider);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    ref.read(mqttServiceProvider).disconnect();
    final useCase = ref.read(logoutUseCaseProvider);
    await useCase();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void _connectMqtt(RiderEntity rider) {
    final bikeId = rider.assignedBikeId;
    if (bikeId == null) return;
    final token = Supabase.instance.client.auth.currentSession?.accessToken ?? 'dev-token';
    ref.read(mqttServiceProvider).connect(bikeId, token);
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final useCase = ref.read(forgotPasswordUseCaseProvider);
    final result = await useCase(email);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: AuthStatus.initial);
        return true;
      },
    );
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }
}

final authControllerProvider =
    NotifierProvider.autoDispose<AuthController, AuthState>(
  AuthController.new,
);
