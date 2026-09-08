import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/enums/command_type.dart';
import '../../domain/entities/bike_command_entity.dart';
import '../../domain/interfaces/i_bike_control_repository.dart';
import '../datasources/bike_control_datasource.dart';
import '../models/bike_command_model.dart';

@LazySingleton(as: IBikeControlRepository)
class BikeControlRepositoryImpl implements IBikeControlRepository {
  const BikeControlRepositoryImpl(this._dataSource);
  final IBikeControlDataSource _dataSource;

  @override
  Future<Either<Failure, BikeCommandEntity>> sendCommand(
    String bikeId,
    CommandType type, {
    String? payload,
  }) async {
    try {
      final model = await _dataSource.sendCommand(
        bikeId,
        type,
        payload: payload,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
