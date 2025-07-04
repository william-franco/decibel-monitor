import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/common/routes/routes.dart';
import 'package:decibel_monitor/src/features/settings/controllers/setting_controller.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  final Routes appRoutes = Routes();
  runApp(
    MyApp(
      appRoutes: appRoutes,
      settingController: locator<SettingController>(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;
  final SettingController settingController;

  const MyApp({
    super.key,
    required this.appRoutes,
    required this.settingController,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingController,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Decibel Monitor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingController.settingModel.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
