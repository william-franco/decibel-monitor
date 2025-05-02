import 'package:decibel_monitor/src/features/decibel/views/decibel_view.dart';
import 'package:go_router/go_router.dart';

class DecibelRoutes {
  static String get decibel => '/decibel';

  final routes = [
    GoRoute(
      path: decibel,
      builder: (context, state) {
        return const DecibelView();
      },
    ),
  ];
}
