import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/diagnostic_entity.dart';
import '../../domain/interfaces/i_diagnostics_repository.dart';
import '../../domain/usecases/get_diagnostics_usecase.dart';
import '../../domain/usecases/get_maintenance_logs_usecase.dart';
import '../../data/models/maintenance_log_model.dart';

final diagnosticsRepositoryProvider = Provider<IDiagnosticsRepository>(
  (ref) => getIt<IDiagnosticsRepository>(),
);

final getDiagnosticsUseCaseProvider = Provider<GetDiagnosticsUseCase>(
  (ref) => getIt<GetDiagnosticsUseCase>(),
);

final getMaintenanceLogsUseCaseProvider = Provider<GetMaintenanceLogsUseCase>(
  (ref) => getIt<GetMaintenanceLogsUseCase>(),
);

final diagnosticsProvider = FutureProvider<DiagnosticEntity?>((ref) async {
  final bikeId = ref.watch(assignedBikeIdProvider) ?? AppConfig.mqttBikeId;
  if (bikeId.isEmpty) return null;
  final useCase = ref.watch(getDiagnosticsUseCaseProvider);
  final result = await useCase(bikeId);
  return result.fold((_) => null, (d) => d);
});

final maintenanceLogsProvider = FutureProvider<List<MaintenanceLogModel>>((
  ref,
) async {
  final bikeId = ref.watch(assignedBikeIdProvider);
  if (bikeId == null) return [];
  final useCase = ref.watch(getMaintenanceLogsUseCaseProvider);
  final result = await useCase(bikeId);
  return result.fold((_) => [], (logs) => logs);
});
