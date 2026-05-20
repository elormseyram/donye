import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/mqtt_service.dart';
import '../../domain/entities/telemetry_entity.dart';
import '../../domain/interfaces/i_telemetry_repository.dart';
import '../datasources/telemetry_local_datasource.dart';
import '../datasources/telemetry_remote_datasource.dart';
import '../models/telemetry_payload_model.dart';

@LazySingleton(as: ITelemetryRepository)
class TelemetryRepositoryImpl implements ITelemetryRepository {
  const TelemetryRepositoryImpl(
    this._mqttService,
    this._remote,
    this._local,
  );

  final MqttService _mqttService;
  final ITelemetryRemoteDataSource _remote;
  final ITelemetryLocalDataSource _local;

  @override
  Stream<TelemetryEntity> get liveStream =>
      _mqttService.telemetryStream.map((json) {
        return TelemetryPayloadModel.fromJson(json).toEntity();
      });

  @override
  Future<Either<Failure, List<TelemetryEntity>>> getHistory(
    String bikeId, {
    int limit = 100,
  }) async {
    try {
      final models = await _remote.getHistory(bikeId, limit: limit);
      await _local.cacheEntries(models);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      try {
        final cached = await _local.getCached(bikeId);
        if (cached.isEmpty) return Left(ServerFailure(e.message));
        return Right(cached.map((m) => m.toEntity()).toList());
      } on CacheException catch (ce) {
        return Left(CacheFailure(ce.message));
      }
    }
  }
}
