import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/rider_entity.dart';
import '../interfaces/i_auth_repository.dart';

@injectable
class GetCurrentRiderUseCase {
  const GetCurrentRiderUseCase(this._repository);
  final IAuthRepository _repository;

  Future<Either<Failure, RiderEntity?>> call() =>
      _repository.getCurrentRider();
}
