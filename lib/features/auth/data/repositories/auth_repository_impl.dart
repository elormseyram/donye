import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart' as app;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/rider_entity.dart';
import '../../domain/interfaces/i_auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/rider_model.dart';

// ---------------------------------------------------------------------------
// Dev bypass — remove once Supabase is configured
// ---------------------------------------------------------------------------
const _devEmail = 'rider@sherides.com';
const _devPassword = 'SheRides2025';
final _devRider = RiderModel(
  id: 'dev-001',
  email: _devEmail,
  fullName: 'Test Rider',
  phoneNumber: '+233200000000',
  avatarUrl: null,
  assignedBikeId: 'dev-001',
  createdAt: DateTime(2025),
  isActive: true,
);
// ---------------------------------------------------------------------------

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._remote, this._local);
  final IAuthRemoteDataSource _remote;
  final IAuthLocalDataSource _local;

  bool get _isDevCached => _local.getCachedRiderJson() != null &&
      (_local.getCachedRiderJson()?['id'] == 'dev-001');

  @override
  Future<Either<Failure, RiderEntity>> login({
    required String email,
    required String password,
  }) async {
    if (email.trim() == _devEmail && password == _devPassword) {
      await _local.cacheRiderJson(_devRider.toJson());
      return Right(_devRider.toEntity());
    }
    try {
      final model = await _remote.login(email: email, password: password);
      await _local.cacheRiderJson(model.toJson());
      return Right(model.toEntity());
    } on app.AppAuthException catch (e) {
      return Left(AppAuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiderEntity>> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String bikeSerialNumber,
  }) async {
    try {
      final model = await _remote.signup(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        bikeSerialNumber: bikeSerialNumber,
      );
      await _local.cacheRiderJson(model.toJson());
      return Right(model.toEntity());
    } on app.AppAuthException catch (e) {
      return Left(AppAuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    if (_isDevCached) {
      await _local.clearRiderCache();
      return const Right(unit);
    }

    Failure? failure;
    try {
      await _remote.logout();
    } on app.AppAuthException catch (e) {
      failure = AppAuthFailure(e.message);
    } catch (e) {
      failure = UnexpectedFailure(e.toString());
    }

    // A failed network request must not leave the rider signed in locally.
    // Supabase may already have removed its persisted session, and retaining
    // this cache would cause getCurrentRider/authStateStream to restore access.
    await _local.clearRiderCache();

    return failure == null ? const Right(unit) : Left(failure);
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(email);
      return const Right(unit);
    } on app.AppAuthException catch (e) {
      return Left(AppAuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiderEntity?>> getCurrentRider() async {
    if (_isDevCached) return Right(_devRider.toEntity());
    try {
      final model = await _remote.getCurrentRider();
      if (model != null) {
        await _local.cacheRiderJson(model.toJson());
        return Right(model.toEntity());
      }
      final cached = _local.getCachedRiderJson();
      if (cached != null) return Right(RiderModel.fromJson(cached).toEntity());
      return const Right(null);
    } on app.AppAuthException catch (e) {
      final cached = _local.getCachedRiderJson();
      if (cached != null) return Right(RiderModel.fromJson(cached).toEntity());
      return Left(AppAuthFailure(e.message));
    } catch (e) {
      final cached = _local.getCachedRiderJson();
      if (cached != null) return Right(RiderModel.fromJson(cached).toEntity());
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<bool> get authStateStream => _remote.authStateStream
      .map((isRemoteAuth) => isRemoteAuth || _isDevCached);
}
