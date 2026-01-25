import 'package:decibel_monitor/src/features/decibel/models/decibel_model.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:flutter/foundation.dart';

typedef _ViewModel = ChangeNotifier;

abstract interface class DecibelViewModel extends _ViewModel {
  DecibelModel get decibelModel;

  Future<void> startListening();
  Future<void> stopListening();
}

class DecibelViewModelImpl extends _ViewModel implements DecibelViewModel {
  final DecibelRepository decibelRepository;

  DecibelViewModelImpl({required this.decibelRepository});

  DecibelModel _decibelModel = DecibelModel();

  @override
  DecibelModel get decibelModel => _decibelModel;

  @override
  Future<void> startListening() async {
    try {
      decibelRepository.setUpdateHandler((newState) {
        _decibelModel = _decibelModel.addToHistory(newState);
        notifyListeners();
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
}
