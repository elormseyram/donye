import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';

class AnalyticsController extends Notifier<void> {
  @override
  void build() {}

  Future<void> refresh() async {
    ref.invalidate(rideSessionsProvider);
    ref.invalidate(weeklyStatsProvider);
  }
}

final analyticsControllerProvider =
    NotifierProvider<AnalyticsController, void>(AnalyticsController.new);
