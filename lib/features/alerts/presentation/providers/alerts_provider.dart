import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../shared/enums/alert_severity.dart';
import '../../../../shared/enums/alert_type.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../telemetry/presentation/providers/telemetry_provider.dart';
import '../../domain/entities/alert_entity.dart';
import '../../domain/interfaces/i_alerts_repository.dart';
import '../../domain/usecases/mark_alert_read_usecase.dart';
import '../../domain/usecases/stream_active_alerts_usecase.dart';

final alertsRepositoryProvider = Provider<IAlertsRepository>(
  (ref) => getIt<IAlertsRepository>(),
);

final streamActiveAlertsUseCaseProvider = Provider<StreamActiveAlertsUseCase>(
  (ref) => getIt<StreamActiveAlertsUseCase>(),
);

final markAlertReadUseCaseProvider = Provider<MarkAlertReadUseCase>(
  (ref) => getIt<MarkAlertReadUseCase>(),
);

final activeAlertsProvider = StreamProvider<List<AlertEntity>>((ref) {
  final bikeId = ref.watch(assignedBikeIdProvider) ?? AppConfig.mqttBikeId;
  if (bikeId.isEmpty) return const Stream.empty();
  final useCase = ref.watch(streamActiveAlertsUseCaseProvider);
  final stored = useCase(bikeId);
  final liveCrashes = ref
      .watch(mqttServiceProvider)
      .alertStream
      .where((json) => json['type'] == 'crash')
      .map(
        (json) => AlertEntity(
          id: 'mqtt-crash-${DateTime.now().microsecondsSinceEpoch}',
          bikeId: bikeId,
          severity: json['severity'] == 'critical'
              ? AlertSeverity.critical
              : AlertSeverity.warning,
          type: AlertType.crash,
          title: '${json['title'] ?? 'Crash detected'}',
          message:
              '${json['message'] ?? 'The bike detected a crash sequence.'}',
          isRead: false,
          isResolved: false,
          createdAt: DateTime.now(),
        ),
      )
      .scan<List<AlertEntity>>(
        (alerts, alert, _) => [alert, ...alerts].take(20).toList(),
        <AlertEntity>[],
      )
      .startWith(<AlertEntity>[]);
  return Rx.combineLatest2(
    stored,
    liveCrashes,
    (List<AlertEntity> saved, List<AlertEntity> live) => [...live, ...saved],
  );
});

final unreadAlertCountProvider = Provider<int>((ref) {
  return ref
          .watch(activeAlertsProvider)
          .value
          ?.where((a) => !a.isRead)
          .length ??
      0;
});
