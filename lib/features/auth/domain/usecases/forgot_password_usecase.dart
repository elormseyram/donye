import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../interfaces/i_auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, Unit>> call(String email) =>
      _repository.forgotPassword(email);
}
