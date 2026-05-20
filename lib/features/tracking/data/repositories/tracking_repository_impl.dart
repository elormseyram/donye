import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/mqtt_service.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/interfaces/i_tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';
import '../models/location_payload_model.dart';

@LazySingleton(as: ITrackingRepository)
class TrackingRepositoryImpl implements ITrackingRepository {
  const TrackingRepositoryImpl(this._mqttService, this._remote);
  final MqttService _mqttService;
  final ITrackingRemoteDataSource _remote;

  @override
  Stream<LocationEntity> get liveLocationStream =>
      _mqttService.locationStream.map(
        (json) => LocationPayloadModel.fromJson(json).toEntity(),
      );

  @override
  Future<Either<Failure, List<LocationEntity>>> getRideRoute(
    String bikeId, {
    DateTime? since,
  }) async {
    try {
      final models = await _remote.getRideRoute(bikeId, since: since);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
