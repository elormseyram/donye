import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/diagnostic_entity.dart';
import '../../data/models/maintenance_log_model.dart';

abstract interface class IDiagnosticsRepository {
  Future<Either<Failure, DiagnosticEntity>> getDiagnostics(String bikeId);
  Future<Either<Failure, List<MaintenanceLogModel>>> getMaintenanceLogs(
    String bikeId,
  );
}
