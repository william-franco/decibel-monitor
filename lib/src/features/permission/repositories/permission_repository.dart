import 'package:decibel_monitor/src/common/constants/constants.dart';
import 'package:flutter/services.dart';

abstract interface class PermissionRepository {
  Future<bool> checkAndRequestPermission();
}

class PermissionRepositoryImpl implements PermissionRepository {
  static const MethodChannel _channel = MethodChannel(Constants.pathChannel);

  @override
  Future<bool> checkAndRequestPermission() async {
    try {
      final bool isGranted =
          await _channel.invokeMethod('checkAndRequestPermission');
      return isGranted;
    } on PlatformException catch (error) {
      // return false;
      throw Exception('Error requesting permission: ${error.message}');
    }
  }
}
