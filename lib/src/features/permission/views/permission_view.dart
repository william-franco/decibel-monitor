import 'package:decibel_monitor/src/features/decibel/routes/decibel_routes.dart';
import 'package:decibel_monitor/src/features/permission/controllers/permission_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PermissionView extends StatefulWidget {
  final PermissionController permissionController;

  const PermissionView({super.key, required this.permissionController});

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  late final PermissionController permissionController;

  @override
  void initState() {
    super.initState();
    permissionController = widget.permissionController;
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _checkPermissionState();
    });
  }

  void _checkPermissionState() {
    if (permissionController.permissionModel.isGranted) {
      context.go(DecibelRoutes.decibel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Permission Check')),
      body: Center(
        child: ListenableBuilder(
          listenable: permissionController,
          builder: (context, child) {
            if (permissionController.permissionModel.isGranted) {
              return Text(
                'Permission granted. Navigating...',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              );
            } else {
              return Text(
                'Microphone permission is not granted. Please enable it in settings.',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              );
            }
          },
        ),
      ),
    );
  }
}
