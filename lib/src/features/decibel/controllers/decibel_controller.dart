import 'package:decibel_monitor/src/features/decibel/models/decibel_model.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:flutter/material.dart';

typedef _Controller = ValueNotifier<DecibelModel>;

abstract interface class DecibelController extends _Controller {
  DecibelController() : super(DecibelModel());

  Future<void> startListening();
  Future<void> stopListening();
}

class DecibelControllerImpl extends _Controller implements DecibelController {
  final DecibelRepository decibelRepository;

  DecibelControllerImpl({
    required this.decibelRepository,
  }) : super(DecibelModel());

  @override
  Future<void> startListening() async {
    try {
      decibelRepository.setUpdateHandler((newValue) {
        value = value.addToHistory(newValue);
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
