import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/rider_entity.dart';
import '../interfaces/i_profile_repository.dart';

@injectable
class UpdateRiderProfileUseCase {
  const UpdateRiderProfileUseCase(this._repository);
  final IProfileRepository _repository;

  Future<Either<Failure, RiderEntity>> call(RiderEntity rider) =>
      _repository.updateRiderProfile(rider);
}
