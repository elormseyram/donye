import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/command_type.dart';
import '../entities/bike_command_entity.dart';
import '../interfaces/i_bike_control_repository.dart';

@injectable
class SendCommandUseCase {
  const SendCommandUseCase(this._repository);
  final IBikeControlRepository _repository;

  Future<Either<Failure, BikeCommandEntity>> call(
    String bikeId,
    CommandType type, {
    String? payload,
  }) => _repository.sendCommand(bikeId, type, payload: payload);
}
