import 'package:decibel_monitor/src/common/constants/constants.dart';
import 'package:flutter/services.dart';

abstract interface class DecibelRepository {
  Future<void> startListening();
  Future<void> stopListening();
  void setUpdateHandler(Function(double) callback);
}

class DecibelRepositoryImpl implements DecibelRepository {
  static const MethodChannel _channel = MethodChannel(Constants.pathChannel);

  @override
  Future<void> startListening() async {
    try {
      await _channel.invokeMethod('startListening');
    } on PlatformException catch (error) {
      throw Exception('Error starting measurement: ${error.message}');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
    } on PlatformException catch (error) {
      throw Exception('Error stopping measurement: ${error.message}');
    }
  }

  @override
  void setUpdateHandler(Function(double) callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'updateDecibel') {
        final double? newValue = call.arguments;
        if (newValue != null) {
          callback(newValue);
        }
      }
    });
  }
}
