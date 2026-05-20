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
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<RiderModel?> getCurrentRider();
  Stream<bool> get authStateStream;
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._client);
  final SupabaseClient _client;

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
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );
      if (response.user == null) {
        throw const app.AppAuthException(message: 'Signup failed. Please try again.');
      }
      // Upsert rider profile row
      await _client.from('riders').upsert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });
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
