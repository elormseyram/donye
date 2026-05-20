import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rider_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, RiderEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, RiderEntity>> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> forgotPassword(String email);

  Future<Either<Failure, RiderEntity?>> getCurrentRider();

  Stream<bool> get authStateStream;
}
