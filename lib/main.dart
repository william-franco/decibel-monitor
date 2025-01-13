import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/common/routes/routes.dart';
import 'package:decibel_monitor/src/features/settings/controllers/setting_controller.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<SettingController>(),
      builder: (context, value, widget) {
        return MaterialApp.router(
          title: 'Decibel Monitor',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          themeMode: value.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routerConfig: Routes.routes,
        );
      },
    );
  }
}
