import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart' as app;
import '../../../../core/constants/app_config.dart';
import '../models/rider_model.dart';
import 'portal_session_cache.dart';
import 'auth_local_datasource.dart';

abstract class IAuthRemoteDataSource {
  Future<RiderModel> login({required String email, required String password});
  Future<RiderModel> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String bikeSerialNumber,
    required String bikeModel,
    required String bikeRegistrationNumber,
    required double batteryCapacityKwh,
  });
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<RiderModel?> getCurrentRider();
  Stream<bool> get authStateStream;
}

@LazySingleton(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(this._client, this._dio, this._local)
      : _portalClient = SupabaseClient(
          AppConfig.dornyePortalUrl,
          AppConfig.dornyePortalPublishableKey,
        ) {
    _restorePortalSession();
  }
  final SupabaseClient _client;
  final Dio _dio;
  final IAuthLocalDataSource _local;
  final SupabaseClient _portalClient;
  final BehaviorSubject<bool> _portalAuth = BehaviorSubject.seeded(false);
  String? _portalSessionToken;
  String? _portalRefreshToken;
  RiderModel? _portalRider;

  @override
  Future<RiderModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _portalClient.functions.invoke(
        'rider-portal',
        body: {
          'action': 'login',
          'email': email.trim().toLowerCase(),
          'password': password,
        },
      );
      final envelope = response.data;
      if (envelope is! Map || envelope['ok'] != true) {
        final message = envelope is Map ? envelope['error']?.toString() : null;
        try {
          final independent = await _client.auth.signInWithPassword(
            email: email.trim().toLowerCase(),
            password: password,
          );
          if (independent.user != null) {
            return _fetchRiderProfile(independent.user!.id);
          }
        } on AuthException {
          // Preserve the more relevant Dornye rider-portal error below.
        }
        throw app.AppAuthException(
          message: message ?? 'Rider login failed. Please try again.',
        );
      }
      final rider = envelope['data'];
      if (rider is! Map || rider['id'] == null || rider['name'] == null) {
        throw const app.AppAuthException(
          message: 'Dornye returned an invalid rider profile.',
        );
      }
      _portalSessionToken = rider['sessionToken']?.toString();
      _portalRefreshToken = rider['refreshToken']?.toString();
      PortalSessionCache.sessionToken = _portalSessionToken;
      PortalSessionCache.riderId = rider['id'].toString();
      PortalSessionCache.riderEmail =
          rider['email']?.toString() ?? email.trim().toLowerCase();
      _portalAuth.add(true);
      Map? dashboard;
      try {
        final dashboardResponse = await _portalClient.functions.invoke(
          'rider-portal',
          body: {
            'action': 'dashboard_refresh',
            'riderId': rider['id'],
            'email': rider['email'] ?? email.trim().toLowerCase(),
            'sessionToken': _portalSessionToken,
          },
        );
        final dashboardEnvelope = dashboardResponse.data;
        if (dashboardEnvelope is Map && dashboardEnvelope['ok'] == true) {
          dashboard = dashboardEnvelope['data'] as Map?;
        }
      } catch (_) {
        // Login remains valid if optional dashboard enrichment is unavailable.
      }
      var assignment = rider['assignment'] ??
          rider['bikeAssignment'] ??
          dashboard?['assignment'] ??
          dashboard?['bikeAssignment'];
      var bike = rider['bike'] ??
          rider['assignedBike'] ??
          dashboard?['bike'] ??
          dashboard?['assignedBike'];
      if (assignment == null && bike == null) {
        final directAssignment = await _fetchDirectPortalAssignment(
          rider['id'].toString(),
        );
        assignment = directAssignment;
        bike = directAssignment?['fleet_bikes'];
      }
      PortalSessionCache.bike = bike is Map
          ? Map<String, dynamic>.from(bike)
          : assignment is Map && assignment['bike'] is Map
              ? Map<String, dynamic>.from(assignment['bike'] as Map)
              : null;
      _portalRider = RiderModel(
        id: rider['id'].toString(),
        email: rider['email']?.toString() ?? email.trim().toLowerCase(),
        fullName: rider['name'].toString(),
        phoneNumber: (rider['phoneNumber'] ?? dashboard?['riderPhone'])
                ?.toString() ??
            '',
        avatarUrl: rider['profileImageUrl']?.toString(),
        assignedBikeId: (rider['assignedBikeId'] ??
                rider['bikeId'] ??
                rider['fleetBikeId'] ??
                dashboard?['assignedBikeId'] ??
                dashboard?['bikeId'] ??
                dashboard?['fleetBikeId'] ??
                (assignment is Map
                    ? (assignment['bikeId'] ?? assignment['bike_id'])
                    : null) ??
                (bike is Map ? bike['id'] : null))
            ?.toString(),
        createdAt: DateTime.tryParse(rider['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        isActive: true,
      );
      await _persistPortalSession();
      return _portalRider!;
    } on app.AppAuthException {
      rethrow;
    } on FunctionException catch (e) {
      throw app.AppAuthException(
        message: e.details?.toString() ??
            e.reasonPhrase ??
            'Rider login failed.',
      );
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
    required String bikeModel,
    required String bikeRegistrationNumber,
    required double batteryCapacityKwh,
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
          'bikeModel': bikeModel.trim(),
          'bikeRegistrationNumber': bikeRegistrationNumber.trim(),
          'batteryCapacityKwh': batteryCapacityKwh,
        },
      );

      return _importAdminSession(response.data, action: 'signup');
    } on DioException catch (e) {
      throw app.AppAuthException(message: _adminErrorMessage(e));
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
      if (_portalSessionToken != null) {
        await _portalClient.functions.invoke(
          'rider-portal',
          body: {
            'action': 'logout',
            'sessionToken': _portalSessionToken,
          },
        );
      }
      await _client.auth.signOut();
      _portalSessionToken = null;
      _portalRefreshToken = null;
      _portalRider = null;
      _portalAuth.add(false);
      PortalSessionCache.clear();
      await _local.clearPortalSession();
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
    if (_portalAuth.value && _portalRider != null) {
      try {
        final response = await _portalClient.functions.invoke(
          'rider-portal',
          body: {
            'action': 'dashboard_refresh',
            'riderId': _portalRider!.id,
            'email': _portalRider!.email,
            'sessionToken': _portalSessionToken,
          },
        );
        final envelope = response.data;
        final dashboard = envelope is Map && envelope['ok'] == true
            ? envelope['data']
            : null;
        if (dashboard is Map) {
          var assignment =
              dashboard['assignment'] ?? dashboard['bikeAssignment'];
          var bike = dashboard['bike'] ??
              dashboard['assignedBike'] ??
              (assignment is Map ? assignment['bike'] : null);
          if (assignment == null && bike == null) {
            final directAssignment = await _fetchDirectPortalAssignment(
              _portalRider!.id,
            );
            assignment = directAssignment;
            bike = directAssignment?['fleet_bikes'];
          }
          if (bike is Map) {
            PortalSessionCache.bike = Map<String, dynamic>.from(bike);
          }
          final assignedBikeId = (dashboard['assignedBikeId'] ??
                  dashboard['bikeId'] ??
                  dashboard['fleetBikeId'] ??
                  (assignment is Map
                      ? (assignment['bikeId'] ?? assignment['bike_id'])
                      : null) ??
                  (bike is Map ? bike['id'] : null))
              ?.toString();
          _portalRider = _portalRider!.copyWith(
            assignedBikeId: assignedBikeId,
          );
          await _persistPortalSession();
        }
      } catch (_) {
        final refreshToken = _portalRefreshToken;
        if (refreshToken != null) {
          try {
            final refreshed = await _portalClient.functions.invoke(
              'rider-portal',
              body: {'action': 'refresh', 'refreshToken': refreshToken},
            );
            final envelope = refreshed.data;
            final payload = envelope is Map && envelope['ok'] == true
                ? envelope['data']
                : null;
            if (payload is Map) {
              _applyPortalRefreshPayload(payload);
            }
          } catch (_) {
            // Keep the last authenticated profile during a transient error.
          }
        }
      }
      return _portalRider;
    }
    final user = _client.auth.currentUser;
    if (user == null) return null;
    try {
      return _fetchRiderProfile(user.id);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<bool> get authStateStream => Rx.combineLatest2<bool, bool, bool>(
        _client.auth.onAuthStateChange
            .map((event) => event.session != null)
            .startWith(_client.auth.currentSession != null),
        _portalAuth.stream,
        (supabaseAuth, portalAuth) => supabaseAuth || portalAuth,
      ).distinct();

  Future<RiderModel> _importAdminSession(
    Map<String, dynamic>? response, {
    required String action,
  }) async {
    final payload = response?['data'] as Map<String, dynamic>?;
    final session = payload?['session'] as Map<String, dynamic>?;
    final rider = payload?['rider'] as Map<String, dynamic>?;
    final refreshToken = session?['refreshToken'] as String?;
    if (rider == null || refreshToken == null) {
      throw app.AppAuthException(
        message: 'The Donye admin server returned an invalid $action response.',
      );
    }

    await _client.auth.setSession(refreshToken);
    return RiderModel.fromJson(rider);
  }

  String _adminErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['error'] ?? data['message'];
      if (message != null) return message.toString();
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty && errors.first is Map) {
        final validationMessage = (errors.first as Map)['message'];
        if (validationMessage != null) return validationMessage.toString();
      }
    }
    if (error.response != null) {
      return 'Donye admin request failed (${error.response!.statusCode}).';
    }
    return 'Could not connect to the Donye admin server.';
  }

  void _applyPortalRefreshPayload(Map payload) {
    _portalSessionToken =
        payload['sessionToken']?.toString() ?? _portalSessionToken;
    PortalSessionCache.sessionToken = _portalSessionToken;
    _portalRefreshToken =
        payload['refreshToken']?.toString() ?? _portalRefreshToken;
    final assignment = payload['assignment'] ?? payload['bikeAssignment'];
    final bike = payload['bike'] ??
        payload['assignedBike'] ??
        (assignment is Map ? assignment['bike'] : null);
    if (bike is Map) {
      PortalSessionCache.bike = Map<String, dynamic>.from(bike);
    }
    final assignedBikeId = (payload['assignedBikeId'] ??
            payload['bikeId'] ??
            (assignment is Map
                ? (assignment['bikeId'] ?? assignment['bike_id'])
                : null) ??
            (bike is Map ? bike['id'] : null))
        ?.toString();
    _portalRider = _portalRider?.copyWith(
      fullName: payload['name']?.toString() ?? _portalRider!.fullName,
      phoneNumber:
          payload['phoneNumber']?.toString() ?? _portalRider!.phoneNumber,
      avatarUrl:
          payload['profileImageUrl']?.toString() ?? _portalRider!.avatarUrl,
      assignedBikeId: assignedBikeId,
    );
  }

  void _restorePortalSession() {
    final saved = _local.getPortalSession();
    if (saved == null) {
      // Upgrade riders cached by older app versions. The deployed portal can
      // verify the rider id/email pair and will refresh the bike assignment;
      // the next interactive login stores the signed session token.
      final cachedRider = _local.getCachedRiderJson();
      if (cachedRider != null) {
        try {
          _portalRider = RiderModel.fromJson(cachedRider);
          PortalSessionCache.riderId = _portalRider!.id;
          PortalSessionCache.riderEmail = _portalRider!.email;
          _portalAuth.add(true);
        } catch (_) {
          // Ignore an obsolete or malformed cache.
        }
      }
      return;
    }
    final riderJson = saved['rider'];
    final token = saved['sessionToken']?.toString();
    if (riderJson is! Map || token == null || token.isEmpty) return;
    try {
      _portalRider = RiderModel.fromJson(Map<String, dynamic>.from(riderJson));
      _portalSessionToken = token;
      _portalRefreshToken = saved['refreshToken']?.toString();
      final bike = saved['bike'];
      PortalSessionCache.bike =
          bike is Map ? Map<String, dynamic>.from(bike) : null;
      PortalSessionCache.sessionToken = token;
      PortalSessionCache.riderId = _portalRider!.id;
      PortalSessionCache.riderEmail = _portalRider!.email;
      _portalAuth.add(true);
    } catch (_) {
      _local.clearPortalSession();
    }
  }

  Future<void> _persistPortalSession() async {
    final rider = _portalRider;
    final token = _portalSessionToken;
    if (rider == null || token == null) return;
    await _local.cachePortalSession({
      'rider': rider.toJson(),
      'sessionToken': token,
      'refreshToken': _portalRefreshToken,
      'bike': PortalSessionCache.bike,
    });
  }

  Future<Map<String, dynamic>?> _fetchDirectPortalAssignment(
    String riderId,
  ) async {
    final token = _portalSessionToken;
    if (token == null || token.isEmpty) return null;
    try {
      final authenticatedPortal = SupabaseClient(
        AppConfig.dornyePortalUrl,
        AppConfig.dornyePortalPublishableKey,
        accessToken: () async => token,
      );
      final row = await authenticatedPortal
          .from('rider_bike_assignments')
          .select('id,bike_id,assigned_at,notes,fleet_bikes(*)')
          .eq('rider_id', riderId)
          .isFilter('returned_at', null)
          .order('assigned_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return row == null ? null : Map<String, dynamic>.from(row);
    } catch (_) {
      // Older portal sessions may not be Supabase JWTs. In that case the
      // Edge Function remains the authoritative assignment source.
      return null;
    }
  }

  Future<RiderModel> _fetchRiderProfile(String userId) async {
    final data = await _client
        .from('riders')
        .select()
        .eq('id', userId)
        .single();
    return RiderModel.fromJson(data);
  }
}
