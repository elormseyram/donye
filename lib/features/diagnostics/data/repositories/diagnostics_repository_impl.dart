import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/diagnostic_entity.dart';
import '../../domain/interfaces/i_diagnostics_repository.dart';
import '../datasources/diagnostics_local_datasource.dart';
import '../datasources/diagnostics_remote_datasource.dart';
import '../models/diagnostic_model.dart';
import '../models/maintenance_log_model.dart';

@LazySingleton(as: IDiagnosticsRepository)
class DiagnosticsRepositoryImpl implements IDiagnosticsRepository {
  const DiagnosticsRepositoryImpl(this._remote, this._local);
  final IDiagnosticsRemoteDataSource _remote;
  final IDiagnosticsLocalDataSource _local;

  @override
  Future<Either<Failure, DiagnosticEntity>> getDiagnostics(
      String bikeId) async {
    try {
      final model = await _remote.getDiagnostics(bikeId);
      await _local.cache(model);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      final cached = await _local.getCached(bikeId);
      if (cached != null) return Right(cached.toEntity());
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MaintenanceLogModel>>> getMaintenanceLogs(
      String bikeId) async {
    try {
      final logs = await _remote.getMaintenanceLogs(bikeId);
      return Right(logs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
