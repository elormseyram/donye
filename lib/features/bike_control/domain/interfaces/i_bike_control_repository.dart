import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/command_type.dart';
import '../entities/bike_command_entity.dart';

abstract interface class IBikeControlRepository {
  Future<Either<Failure, BikeCommandEntity>> sendCommand(
    String bikeId,
    CommandType type, {
    String? payload,
  });
}
