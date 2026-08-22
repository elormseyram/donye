import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/rider_entity.dart';
import '../entities/bike_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, BikeEntity>> getAssignedBike(String bikeId);
  Future<Either<Failure, BikeEntity>> updateBatteryCapacity(
    String bikeId,
    double capacityKwh,
  );
  Future<Either<Failure, RiderEntity>> updateRiderProfile(RiderEntity rider);
}
