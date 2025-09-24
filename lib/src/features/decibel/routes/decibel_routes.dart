import 'package:decibel_monitor/src/common/dependency_injectors/dependency_injector.dart';
import 'package:decibel_monitor/src/features/decibel/view_models/decibel_view_model.dart';
import 'package:decibel_monitor/src/features/decibel/views/decibel_view.dart';
import 'package:go_router/go_router.dart';

class DecibelRoutes {
  static String get decibel => '/decibel';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: decibel,
      builder: (context, state) {
        return DecibelView(decibelViewModel: locator<DecibelViewModel>());
      },
    ),
  ];
}
