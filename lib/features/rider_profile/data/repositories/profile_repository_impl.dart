import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/data/models/rider_model.dart';
import '../../../auth/domain/entities/rider_entity.dart';
import '../../domain/entities/bike_entity.dart';
import '../../domain/interfaces/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/bike_model.dart';

@LazySingleton(as: IProfileRepository)
class ProfileRepositoryImpl implements IProfileRepository {
  const ProfileRepositoryImpl(this._remote);
  final IProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, BikeEntity>> getAssignedBike(String bikeId) async {
    try {
      final model = await _remote.getBike(bikeId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RiderEntity>> updateRiderProfile(
    RiderEntity rider,
  ) async {
    try {
      final data = {
        'full_name': rider.fullName,
        'phone_number': rider.phoneNumber,
        'avatar_url': rider.avatarUrl,
      };
      final model = await _remote.updateRider(data, rider.id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
