import 'package:injectable/injectable.dart';
import '../entities/location_entity.dart';
import '../interfaces/i_tracking_repository.dart';

@injectable
class StreamLiveLocationUseCase {
  const StreamLiveLocationUseCase(this._repository);
  final ITrackingRepository _repository;

  Stream<LocationEntity> call() => _repository.liveLocationStream;
}
