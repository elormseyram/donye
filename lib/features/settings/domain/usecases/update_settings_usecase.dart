import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_settings_entity.dart';
import '../interfaces/i_settings_repository.dart';

@injectable
class UpdateSettingsUseCase {
  const UpdateSettingsUseCase(this._repository);
  final ISettingsRepository _repository;

  Future<Either<Failure, void>> call(AppSettingsEntity settings) =>
      _repository.saveSettings(settings);
}
