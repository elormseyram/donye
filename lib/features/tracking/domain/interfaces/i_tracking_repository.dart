import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract interface class ITrackingRepository {
  Stream<LocationEntity> get liveLocationStream;
  Future<Either<Failure, List<LocationEntity>>> getRideRoute(
    String bikeId, {
    DateTime? since,
  });
}
