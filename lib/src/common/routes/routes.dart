import 'package:decibel_monitor/src/features/decibel/routes/decibel_routes.dart';
import 'package:decibel_monitor/src/features/permission/routes/permission_routes.dart';
import 'package:decibel_monitor/src/features/settings/routes/setting_routes.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static String get home => PermissionRoutes.permisson;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [
      ...DecibelRoutes().routes,
      ...PermissionRoutes().routes,
      ...SettingRoutes().routes,
    ],
  );
}
