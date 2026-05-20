import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';
import '../interfaces/i_tracking_repository.dart';

@injectable
class GetRideRouteUseCase {
  const GetRideRouteUseCase(this._repository);
  final ITrackingRepository _repository;

  Future<Either<Failure, List<LocationEntity>>> call(
    String bikeId, {
    DateTime? since,
  }) =>
      _repository.getRideRoute(bikeId, since: since);
}
