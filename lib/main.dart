import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/common/routes/routes.dart';
import 'package:decibel_monitor/src/features/permission/controllers/permission_controller.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  dependencyInjector();
  WidgetsFlutterBinding.ensureInitialized();
  await locator<PermissionController>().initMicrophonePermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Decibel Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: Routes.routes,
    );
  }
}
