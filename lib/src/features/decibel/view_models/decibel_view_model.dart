import 'package:decibel_monitor/src/common/state_management/state_management.dart';
import 'package:decibel_monitor/src/features/decibel/models/decibel_model.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:flutter/foundation.dart';

typedef _ViewModel = StateManagement<DecibelModel>;

abstract interface class DecibelViewModel extends _ViewModel {
  Future<void> startListening();
  Future<void> stopListening();
}

class DecibelViewModelImpl extends _ViewModel implements DecibelViewModel {
  final DecibelRepository decibelRepository;

  DecibelViewModelImpl({required this.decibelRepository});

  @override
  DecibelModel build() => DecibelModel();

  @override
  Future<void> startListening() async {
    try {
      decibelRepository.setUpdateHandler((newState) {
        final model = state.addToHistory(newState);
        _emit(model);
      });
      await decibelRepository.startListening();
    } catch (error) {
      debugPrint('$error');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await decibelRepository.stopListening();
    } catch (error) {
      debugPrint('$error');
    }
  }

  void _emit(DecibelModel newState) {
    emitState(newState);
    debugPrint('DecibelViewModel: ${state.currentValue}');
  }
}
