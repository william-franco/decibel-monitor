import 'package:decibel_monitor/src/features/permission/views/permission_view.dart';
import 'package:go_router/go_router.dart';

class PermissionRoutes {
  static String get permisson => '/permisson';

  final routes = [
    GoRoute(
      path: permisson,
      builder: (context, state) {
        return const PermissionView();
      },
    ),
  ];
}
