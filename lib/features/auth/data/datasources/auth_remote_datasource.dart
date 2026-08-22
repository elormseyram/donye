import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart' as app;
import '../models/rider_model.dart';

abstract class IAuthRemoteDataSource {
  Future<RiderModel> login({required String email, required String password});
  Future<RiderModel> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String bikeSerialNumber,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<RiderModel?> getCurrentRider();
  Stream<bool> get authStateStream;
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._client, this._dio);
  final SupabaseClient _client;
  final Dio _dio;

  @override
  Future<RiderModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const app.AppAuthException(message: 'Login failed. Please try again.');
      }
      return _fetchRiderProfile(response.user!.id);
    } on app.AppAuthException {
      rethrow;
    } on AuthException catch (e) {
      throw app.AppAuthException(message: e.message);
    } catch (e) {
      throw app.AppAuthException(message: e.toString());
    }
  }

  @override
  Future<RiderModel> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String bikeSerialNumber,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/signup',
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'bikeSerialNumber': bikeSerialNumber.trim(),
        },
      );

      final payload = response.data?['data'] as Map<String, dynamic>?;
      final session = payload?['session'] as Map<String, dynamic>?;
      final rider = payload?['rider'] as Map<String, dynamic>?;
      final refreshToken = session?['refreshToken'] as String?;
      if (rider == null || refreshToken == null) {
        throw const app.AppAuthException(
          message: 'The admin server returned an invalid signup response.',
        );
      }

      // The admin backend creates the rider and assigns the bike. Import its
      // session so existing Supabase realtime/RLS data sources keep working.
      await _client.auth.setSession(refreshToken);
      return RiderModel.fromJson(rider);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? (data['error'] ?? data['message'])?.toString()
          : null;
      throw app.AppAuthException(
        message: message ?? 'Could not connect to the Donye admin server.',
      );
    } on app.AppAuthException {
      rethrow;
    } on AuthException catch (e) {
      throw app.AppAuthException(message: e.message);
    } catch (e) {
      throw app.AppAuthException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw app.AppAuthException(message: e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw app.AppAuthException(message: e.message);
    } catch (e) {
      throw app.AppAuthException(message: e.toString());
    }
  }

  @override
  Future<RiderModel?> getCurrentRider() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    try {
      return _fetchRiderProfile(user.id);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<bool> get authStateStream => _client.auth.onAuthStateChange
      .map((event) => event.session != null)
      .startWith(_client.auth.currentSession != null);

  Future<RiderModel> _fetchRiderProfile(String userId) async {
    final data = await _client
        .from('riders')
        .select()
        .eq('id', userId)
        .single();
    return RiderModel.fromJson(data);
  }
}
