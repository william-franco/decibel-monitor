import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/features/permission/view_models/permission_view_model.dart';
import 'package:decibel_monitor/src/features/permission/views/permission_view.dart';
import 'package:go_router/go_router.dart';

class PermissionRoutes {
  static String get permisson => '/permisson';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: permisson,
      builder: (context, state) {
        return PermissionView(
          permissionViewModel: locator<PermissionViewModel>(),
        );
      },
    ),
  ];
}
