import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bike_entity.dart';
import '../interfaces/i_profile_repository.dart';

@injectable
class GetAssignedBikeUseCase {
  const GetAssignedBikeUseCase(this._repository);
  final IProfileRepository _repository;

  Future<Either<Failure, BikeEntity>> call(String bikeId) =>
      _repository.getAssignedBike(bikeId);
}
