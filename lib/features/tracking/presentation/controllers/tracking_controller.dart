import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/location_entity.dart';
import '../providers/tracking_provider.dart';

class TrackingController extends AutoDisposeNotifier<LocationEntity?> {
  @override
  LocationEntity? build() {
    ref.listen<AsyncValue<LocationEntity>>(
      liveLocationProvider,
      (_, next) => next.whenData((loc) => state = loc),
    );
    return ref.read(currentLocationProvider);
  }
}

final trackingControllerProvider =
    AutoDisposeNotifierProvider<TrackingController, LocationEntity?>(
      TrackingController.new,
    );
