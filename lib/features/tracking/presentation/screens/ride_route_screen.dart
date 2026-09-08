import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/services/google_maps_loader.dart';
import '../../../../core/widgets/sr_empty_state.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/sr_skeleton.dart';
import '../providers/tracking_provider.dart';

class RideRouteScreen extends ConsumerStatefulWidget {
  const RideRouteScreen({super.key});

  @override
  ConsumerState<RideRouteScreen> createState() => _RideRouteScreenState();
}

class _RideRouteScreenState extends ConsumerState<RideRouteScreen> {
  GoogleMapController? _mapController;
  static const _defaultLatLng = LatLng(5.6037, -0.1870);

  @override
  Widget build(BuildContext context) {
    if (AppConfig.googleMapsApiKey.isEmpty || !isGoogleMapsReady) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ride Route')),
        body: const Center(
          child: SrEmptyState(
            iconWidget: DornyeLogo(size: 64),
            title: 'Map unavailable',
            subtitle:
                'Add a Google Maps API key to the local app configuration.',
          ),
        ),
      );
    }
    final routeAsync = ref.watch(rideRouteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Route')),
      body: routeAsync.when(
        loading: () => const GenericListSkeleton(),
        error: (_, __) => const SrEmptyState(
          icon: Icons.map_outlined,
          title: 'Route unavailable',
          subtitle: 'Could not load the ride route.',
        ),
        data: (route) {
          if (route.isEmpty) {
            return const SrEmptyState(
              icon: Icons.route_outlined,
              title: 'No route recorded',
              subtitle: 'Route data will appear once your ride begins.',
            );
          }

          final points = route
              .map((l) => LatLng(l.latitude, l.longitude))
              .toList();

          final bounds = _computeBounds(points);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _defaultLatLng,
                  zoom: 14,
                ),
                onMapCreated: (c) {
                  _mapController = c;
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => _mapController?.animateCamera(
                      CameraUpdate.newLatLngBounds(bounds, 48),
                    ),
                  );
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('full_route'),
                    points: points,
                    color: AppColors.primary,
                    width: 4,
                  ),
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('start'),
                    position: points.first,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                    infoWindow: const InfoWindow(title: 'Start'),
                  ),
                  Marker(
                    markerId: const MarkerId('end'),
                    position: points.last,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                    infoWindow: const InfoWindow(title: 'Last known'),
                  ),
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: _RouteSummaryBar(pointCount: points.length),
              ),
            ],
          );
        },
      ),
    );
  }

  LatLngBounds _computeBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _RouteSummaryBar extends StatelessWidget {
  const _RouteSummaryBar({required this.pointCount});
  final int pointCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.route, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$pointCount GPS points recorded',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
