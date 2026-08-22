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
// ---------------------------------------------------------------------------

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._remote, this._local);
  final IAuthRemoteDataSource _remote;
  final IAuthLocalDataSource _local;

  @override
  Future<Either<Failure, RiderEntity>> login({
    required String email,
    required String password,
  }) async {
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
    required String bikeModel,
    required String bikeRegistrationNumber,
    required double batteryCapacityKwh,
  }) async {
    try {
      final model = await _remote.signup(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        bikeSerialNumber: bikeSerialNumber,
        bikeModel: bikeModel,
        bikeRegistrationNumber: bikeRegistrationNumber,
        batteryCapacityKwh: batteryCapacityKwh,
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
  Stream<bool> get authStateStream => _remote.authStateStream.map(
        (remoteAuthenticated) =>
            remoteAuthenticated || _local.getCachedRiderJson() != null,
      );
}
