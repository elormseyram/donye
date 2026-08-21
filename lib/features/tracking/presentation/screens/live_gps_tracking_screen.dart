import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../providers/tracking_provider.dart';
import '../widgets/speed_overlay_chip.dart';
import '../widgets/map_controls_overlay.dart';

class LiveGpsTrackingScreen extends ConsumerStatefulWidget {
  const LiveGpsTrackingScreen({super.key});

  @override
  ConsumerState<LiveGpsTrackingScreen> createState() =>
      _LiveGpsTrackingScreenState();
}

class _LiveGpsTrackingScreenState
    extends ConsumerState<LiveGpsTrackingScreen> {
  GoogleMapController? _mapController;
  bool _showRoute = true;
  static const _defaultLatLng = LatLng(5.6037, -0.1870); // Accra, Ghana

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(currentLocationProvider);
    final routeAsync = ref.watch(rideRouteProvider);

    final bikeLatLng = location != null
        ? LatLng(location.latitude, location.longitude)
        : _defaultLatLng;

    final routePoints = routeAsync.valueOrNull
            ?.map((l) => LatLng(l.latitude, l.longitude))
            .toList() ??
        [];

    final markers = {
      if (location != null)
        Marker(
          markerId: const MarkerId('bike'),
          position: bikeLatLng,
          infoWindow: InfoWindow(
            title: 'Bike',
            snippet: '${location.speedKmh.toStringAsFixed(0)} km/h',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange),
        ),
    };

    final polylines = {
      if (_showRoute && routePoints.length > 1)
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: AppColors.primary,
          width: 4,
        ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => context.goNamed(RouteNames.rideRoute),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: bikeLatLng,
              zoom: 15,
            ),
            onMapCreated: (c) => _mapController = c,
            markers: markers,
            polylines: polylines,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          // Speed overlay
          if (location != null)
            Positioned(
              bottom: AppSpacing.lg + 16,
              left: AppSpacing.lg,
              child: SpeedOverlayChip(speedKmh: location.speedKmh),
            ),
          // Map controls
          Positioned(
            right: AppSpacing.lg,
            bottom: AppSpacing.lg + 16,
            child: MapControlsOverlay(
              isRouteVisible: _showRoute,
              onCenterBike: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(bikeLatLng),
                );
              },
              onToggleRoute: () =>
                  setState(() => _showRoute = !_showRoute),
            ),
          ),
          // No signal banner
          if (location == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.warning.withValues(alpha: 0.9),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.lg,
                ),
                child: const Text(
                  'Waiting for GPS signal…',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
