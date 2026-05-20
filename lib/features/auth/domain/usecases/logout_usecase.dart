import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../interfaces/i_auth_repository.dart';

@injectable
class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.logout();
}
