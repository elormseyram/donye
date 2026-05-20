import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_settings_entity.dart';

abstract class ISettingsRepository {
  Either<Failure, AppSettingsEntity> getSettings();
  Future<Either<Failure, void>> saveSettings(AppSettingsEntity settings);
}
