import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rider_entity.dart';
import '../interfaces/i_auth_repository.dart';

@injectable
class LoginUseCase {
  const LoginUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, RiderEntity>> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}
