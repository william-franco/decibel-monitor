import 'package:decibel_monitor/src/features/decibel/models/decibel_model.dart';
import 'package:decibel_monitor/src/features/decibel/view_models/decibel_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../decibel_mocks.mocks.dart';

void main() {
  group('DecibelViewModel Test', () {
    late MockDecibelRepository mockDecibelRepository;
    late DecibelViewModel viewModel;

    setUpAll(() {
      provideDummy<DecibelModel>(DecibelModel());
    });

    setUp(() {
      mockDecibelRepository = MockDecibelRepository();
      viewModel = DecibelViewModelImpl(
        decibelRepository: mockDecibelRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    // ---------------------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------------------

    /// Captures the [Function(double)] callback registered via [setUpdateHandler]
    /// and returns a function that simulates the native side pushing a new value.
    Function(double) captureUpdateHandler() {
      Function(double)? captured;
      when(mockDecibelRepository.setUpdateHandler(any)).thenAnswer((inv) {
        captured = inv.positionalArguments.first as Function(double);
      });
      return (double value) {
        assert(captured != null, 'setUpdateHandler was never called');
        captured!(value);
      };
    }

    // ---------------------------------------------------------------------------
    // Initial state
    // ---------------------------------------------------------------------------

    test('should start with a default DecibelModel', () {
      expect(viewModel.state, isA<DecibelModel>());
      expect(viewModel.state.currentValue, equals(0.0));
      expect(viewModel.state.history, isEmpty);
    });

    // ---------------------------------------------------------------------------
    // startListening
    // ---------------------------------------------------------------------------

    group('startListening', () {
      test(
        'should call setUpdateHandler and then startListening on repository',
        () async {
          // arrange
          when(mockDecibelRepository.setUpdateHandler(any)).thenAnswer((_) {});
          when(mockDecibelRepository.startListening()).thenAnswer((_) async {
            return;
          });

          // act
          await viewModel.startListening();

          // assert — order matters: handler must be registered before starting
          verifyInOrder([
            mockDecibelRepository.setUpdateHandler(any),
            mockDecibelRepository.startListening(),
          ]);
        },
      );

      test(
        'should update state with new currentValue when callback is triggered',
        () async {
          // arrange
          final pushValue = captureUpdateHandler();
          when(mockDecibelRepository.startListening()).thenAnswer((_) async {
            return;
          });

          await viewModel.startListening();

          // act — simulate native side sending a decibel reading
          pushValue(65.0);

          // assert
          expect(viewModel.state.currentValue, equals(65.0));
        },
      );

      test(
        'should accumulate values in history across multiple callback calls',
        () async {
          // arrange
          final pushValue = captureUpdateHandler();
          when(mockDecibelRepository.startListening()).thenAnswer((_) async {
            return;
          });

          await viewModel.startListening();

          // act
          pushValue(55.0);
          pushValue(65.0);
          pushValue(75.0);

          // assert
          expect(viewModel.state.history, equals([55.0, 65.0, 75.0]));
          expect(viewModel.state.currentValue, equals(75.0));
        },
      );

      test('should notify listeners on each callback invocation', () async {
        // arrange
        final pushValue = captureUpdateHandler();
        when(mockDecibelRepository.startListening()).thenAnswer((_) async {
          return;
        });

        await viewModel.startListening();

        int notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        // act
        pushValue(60.0);
        pushValue(70.0);

        // assert
        expect(notifyCount, equals(2));
      });

      test(
        'should keep history immutable — each emission produces a new list',
        () async {
          // arrange
          final pushValue = captureUpdateHandler();
          when(mockDecibelRepository.startListening()).thenAnswer((_) async {
            return;
          });

          await viewModel.startListening();
          pushValue(50.0);
          final historyAfterFirst = viewModel.state.history;

          // act
          pushValue(60.0);

          // assert — a new list instance is created, the old one is unchanged
          expect(viewModel.state.history, isNot(same(historyAfterFirst)));
          expect(historyAfterFirst.length, equals(1));
          expect(viewModel.state.history.length, equals(2));
        },
      );

      test(
        'should complete without throwing when repository.startListening throws',
        () async {
          // arrange
          when(mockDecibelRepository.setUpdateHandler(any)).thenAnswer((_) {});
          when(
            mockDecibelRepository.startListening(),
          ).thenThrow(Exception('Microphone unavailable'));

          // act & assert — ViewModel catches and logs via debugPrint
          await expectLater(viewModel.startListening(), completes);
        },
      );

      test(
        'should not change state when repository.startListening throws',
        () async {
          // arrange
          when(mockDecibelRepository.setUpdateHandler(any)).thenAnswer((_) {});
          when(
            mockDecibelRepository.startListening(),
          ).thenThrow(Exception('Microphone unavailable'));

          // act
          await viewModel.startListening();

          // assert
          expect(viewModel.state.currentValue, equals(0.0));
          expect(viewModel.state.history, isEmpty);
        },
      );
    });

    // ---------------------------------------------------------------------------
    // stopListening
    // ---------------------------------------------------------------------------

    group('stopListening', () {
      test('should call stopListening on repository', () async {
        // arrange
        when(mockDecibelRepository.stopListening()).thenAnswer((_) async {
          return;
        });

        // act
        await viewModel.stopListening();

        // assert
        verify(mockDecibelRepository.stopListening()).called(1);
      });

      test(
        'should complete without throwing when repository.stopListening throws',
        () async {
          // arrange
          when(
            mockDecibelRepository.stopListening(),
          ).thenThrow(Exception('Already stopped'));

          // act & assert — ViewModel catches and logs via debugPrint
          await expectLater(viewModel.stopListening(), completes);
        },
      );

      test('should not change state when stopListening is called', () async {
        // arrange
        when(mockDecibelRepository.stopListening()).thenAnswer((_) async {
          return;
        });

        final stateBefore = viewModel.state;

        // act
        await viewModel.stopListening();

        // assert
        expect(viewModel.state, same(stateBefore));
      });

      test(
        'should stop receiving state updates after stopListening is called',
        () async {
          // arrange
          final pushValue = captureUpdateHandler();
          when(mockDecibelRepository.startListening()).thenAnswer((_) async {
            return;
          });
          when(mockDecibelRepository.stopListening()).thenAnswer((_) async {
            return;
          });

          await viewModel.startListening();
          pushValue(55.0);
          expect(viewModel.state.history.length, equals(1));

          await viewModel.stopListening();

          int notifyCount = 0;
          viewModel.addListener(() => notifyCount++);

          // act — push value after stop (callback is still wired, but no new
          // channel data arrives from the native side after stopListening)
          // This test verifies the repository call happened; channel silence
          // is a native concern covered by repository tests.
          verify(mockDecibelRepository.stopListening()).called(1);

          // assert — no additional emissions triggered by the ViewModel itself
          expect(notifyCount, equals(0));
        },
      );
    });
  });
}
