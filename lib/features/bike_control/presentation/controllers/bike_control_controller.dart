import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/command_status.dart';
import '../../../../shared/enums/command_type.dart';
import '../providers/bike_control_provider.dart';

class BikeControlController
    extends AutoDisposeNotifier<AsyncValue<CommandStatus?>> {
  @override
  AsyncValue<CommandStatus?> build() => const AsyncValue.data(null);

  Future<void> sendCommand(CommandType type, {String? payload}) async {
    final bikeId = ref.read(assignedBikeIdProvider);
    if (bikeId == null) {
      state = AsyncValue.error('No bike assigned', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    final useCase = ref.read(sendCommandUseCaseProvider);
    final result = await useCase(bikeId, type, payload: payload);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (command) => AsyncValue.data(command.status),
    );
  }

  Future<void> lock() => sendCommand(CommandType.lock);
  Future<void> unlock() => sendCommand(CommandType.unlock);
  Future<void> honk() => sendCommand(CommandType.honk);
  Future<void> lightsOn() => sendCommand(CommandType.lightsOn);
  Future<void> lightsOff() => sendCommand(CommandType.lightsOff);
  Future<void> disable() => sendCommand(CommandType.disable);
  Future<void> enable() => sendCommand(CommandType.enable);
}

final bikeControlControllerProvider = AutoDisposeNotifierProvider<
    BikeControlController, AsyncValue<CommandStatus?>>(
  BikeControlController.new,
);
