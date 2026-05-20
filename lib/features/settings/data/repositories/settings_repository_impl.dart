import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/interfaces/i_settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepositoryImpl implements ISettingsRepository {
  const SettingsRepositoryImpl(this._local);
  final ISettingsLocalDataSource _local;

  @override
  Either<Failure, AppSettingsEntity> getSettings() {
    try {
      return Right(_local.getSettings());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(AppSettingsEntity settings) async {
    try {
      await _local.saveSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
