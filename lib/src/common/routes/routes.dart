import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: LauncherRoutes.apps,
    routes: [
      ...LauncherRoutes.routes,
      ...SettingRoutes.routes,
    ],
  );
}