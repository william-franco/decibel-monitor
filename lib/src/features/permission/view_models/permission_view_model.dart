import 'package:decibel_monitor/src/common/state_management/state_management.dart';
import 'package:decibel_monitor/src/features/permission/models/permission_model.dart';
import 'package:decibel_monitor/src/features/permission/repositories/permission_repository.dart';
import 'package:flutter/foundation.dart';

typedef _ViewModel = StateManagement<PermissionModel>;

abstract interface class PermissionViewModel extends _ViewModel {
  PermissionViewModel(super.initialValue);

  Future<void> initMicrophonePermission();
}

class PermissionViewModelImpl extends _ViewModel
    implements PermissionViewModel {
  final PermissionRepository permissionRepository;

  PermissionViewModelImpl({required this.permissionRepository})
    : super(PermissionModel());

  @override
  Future<void> initMicrophonePermission() async {
    final isGranted = await permissionRepository.checkAndRequestPermission();
    final model = state.copyWith(isGranted: isGranted);
    _emit(model);
  }

  void _emit(PermissionModel newState) {
    emitState(newState);
    debugPrint('PermissionViewModel: ${state.isGranted}');
  }
}
