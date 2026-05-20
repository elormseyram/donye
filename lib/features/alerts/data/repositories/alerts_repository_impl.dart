import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/interfaces/i_alerts_repository.dart';
import '../datasources/alerts_remote_datasource.dart';
import '../models/alert_model.dart';

@LazySingleton(as: IAlertsRepository)
class AlertsRepositoryImpl implements IAlertsRepository {
  const AlertsRepositoryImpl(this._remote);
  final IAlertsRemoteDataSource _remote;

  @override
  Stream<List<AlertEntity>> streamActiveAlerts(String bikeId) {
    return _remote.streamActiveAlerts(bikeId).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> markAlertRead(String alertId) async {
    try {
      await _remote.markAlertRead(alertId);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
