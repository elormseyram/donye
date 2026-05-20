import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/telemetry_entity.dart';

abstract interface class ITelemetryRepository {
  Stream<TelemetryEntity> get liveStream;
  Future<Either<Failure, List<TelemetryEntity>>> getHistory(
    String bikeId, {
    int limit = 100,
  });
}
