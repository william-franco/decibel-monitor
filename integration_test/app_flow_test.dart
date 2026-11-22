import 'package:decibel_monitor/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('decibel monitor reaches permission or home screen', (
    tester,
  ) async {
    await app.main();
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (_hasDecibelContent(tester)) {
        break;
      }
    }

    expect(_hasDecibelContent(tester), isTrue);
  });
}

bool _hasDecibelContent(WidgetTester tester) {
  return find.text('Permission Check').evaluate().isNotEmpty ||
      find.text('Decibel Monitor').evaluate().isNotEmpty ||
      find
          .textContaining('permission is not granted')
          .evaluate()
          .isNotEmpty ||
      find
          .textContaining('Permission granted')
          .evaluate()
          .isNotEmpty;
}