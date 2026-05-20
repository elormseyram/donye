import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/telemetry_entity.dart';
import '../interfaces/i_telemetry_repository.dart';

@injectable
class GetTelemetryHistoryUseCase {
  const GetTelemetryHistoryUseCase(this._repository);
  final ITelemetryRepository _repository;

  Future<Either<Failure, List<TelemetryEntity>>> call(
    String bikeId, {
    int limit = 100,
  }) =>
      _repository.getHistory(bikeId, limit: limit);
}
