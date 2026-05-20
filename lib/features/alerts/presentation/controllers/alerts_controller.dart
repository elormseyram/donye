import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/notification_service.dart';
import '../providers/alerts_provider.dart';

class AlertsController extends Notifier<void> {
  @override
  void build() {}

  Future<void> markRead(String alertId) async {
    final useCase = ref.read(markAlertReadUseCaseProvider);
    await useCase(alertId);
    ref.invalidate(activeAlertsProvider);
  }

  Future<void> showNotificationForAlert({
    required String title,
    required String body,
  }) async {
    await getIt<NotificationService>().showAlertNotification(
      title: title,
      body: body,
    );
  }
}

final alertsControllerProvider =
    NotifierProvider<AlertsController, void>(AlertsController.new);
