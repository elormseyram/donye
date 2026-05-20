import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/command_type.dart';
import '../entities/bike_command_entity.dart';
import 'send_command_usecase.dart';

@injectable
class LockBikeUseCase {
  const LockBikeUseCase(this._sendCommand);
  final SendCommandUseCase _sendCommand;

  Future<Either<Failure, BikeCommandEntity>> call(String bikeId) =>
      _sendCommand(bikeId, CommandType.lock);
}
