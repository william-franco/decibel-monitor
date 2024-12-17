import 'package:decibel_monitor/src/features/decibel/routes/decibel_routes.dart';
import 'package:decibel_monitor/src/features/permission/routes/permission_routes.dart';
import 'package:decibel_monitor/src/features/settings/routes/setting_routes.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: PermissionRoutes.permisson,
    routes: [
      ...PermissionRoutes.routes,
      ...DecibelRoutes.routes,
      ...SettingRoutes.routes,
    ],
  );
}
