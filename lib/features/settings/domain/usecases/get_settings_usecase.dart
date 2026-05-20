import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_settings_entity.dart';
import '../interfaces/i_settings_repository.dart';

@injectable
class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);
  final ISettingsRepository _repository;

  Either<Failure, AppSettingsEntity> call() => _repository.getSettings();
}
