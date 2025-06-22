import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/features/settings/controllers/setting_controller.dart';
import 'package:decibel_monitor/src/features/settings/views/setting_view.dart';
import 'package:go_router/go_router.dart';

class SettingRoutes {
  static String get setting => '/setting';

  final routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return SettingView(settingController: locator<SettingController>());
      },
    ),
  ];
}
