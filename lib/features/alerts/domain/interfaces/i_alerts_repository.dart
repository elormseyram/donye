import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/alert_entity.dart';

abstract class IAlertsRepository {
  Stream<List<AlertEntity>> streamActiveAlerts(String bikeId);
  Future<Either<Failure, void>> markAlertRead(String alertId);
}
