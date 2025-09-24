import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/features/settings/view_models/setting_view_model.dart';
import 'package:decibel_monitor/src/features/settings/views/setting_view.dart';
import 'package:go_router/go_router.dart';

class SettingRoutes {
  static String get setting => '/setting';

  final routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return SettingView(settingViewModel: locator<SettingViewModel>());
      },
    ),
  ];
}
