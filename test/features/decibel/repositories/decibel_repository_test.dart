import 'package:decibel_monitor/src/common/constants/value_constant.dart';
import 'package:decibel_monitor/src/features/decibel/repositories/decibel_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DecibelRepository Test', () {
    late DecibelRepository repository;
    late MethodChannel channel;

    void setChannelHandler(Future<dynamic> Function(MethodCall call) handler) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    }

    setUp(() {
      channel = MethodChannel(ValueConstant.pathChannel);
      repository = DecibelRepositoryImpl();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    // ---------------------------------------------------------------------------
    // startListening
    // ---------------------------------------------------------------------------

    group('startListening', () {
      test('should invoke startListening on the channel', () async {
        // arrange
        String? capturedMethod;
        setChannelHandler((call) async {
          capturedMethod = call.method;
          return null;
        });

        // act
        await repository.startListening();

        // assert
        expect(capturedMethod, equals('startListening'));
      });

      test(
        'should complete without error when channel call succeeds',
        () async {
          // arrange
          setChannelHandler((_) async => null);

          // act & assert
          await expectLater(repository.startListening(), completes);
        },
      );

      test('should throw Exception with correct message '
          'when channel throws PlatformException', () async {
        // arrange
        setChannelHandler(
          (_) async => throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Microphone not available',
          ),
        );

        // act & assert
        expect(
          () => repository.startListening(),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('Error starting measurement:'),
            ),
          ),
        );
      });

      test(
        'should only catch PlatformException — generic exceptions propagate',
        () async {
          // arrange
          setChannelHandler((_) async => throw Exception('Generic error'));

          // act & assert
          expect(() => repository.startListening(), throwsA(isA<Exception>()));
        },
      );
    });

    // ---------------------------------------------------------------------------
    // stopListening
    // ---------------------------------------------------------------------------

    group('stopListening', () {
      test('should invoke stopListening on the channel', () async {
        // arrange
        String? capturedMethod;
        setChannelHandler((call) async {
          capturedMethod = call.method;
          return null;
        });

        // act
        await repository.stopListening();

        // assert
        expect(capturedMethod, equals('stopListening'));
      });

      test(
        'should complete without error when channel call succeeds',
        () async {
          // arrange
          setChannelHandler((_) async => null);

          // act & assert
          await expectLater(repository.stopListening(), completes);
        },
      );

      test('should throw Exception with correct message '
          'when channel throws PlatformException', () async {
        // arrange
        setChannelHandler(
          (_) async => throw PlatformException(
            code: 'ERROR',
            message: 'Already stopped',
          ),
        );

        // act & assert
        expect(
          () => repository.stopListening(),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('Error stopping measurement:'),
            ),
          ),
        );
      });
    });

    // ---------------------------------------------------------------------------
    // setUpdateHandler
    // ---------------------------------------------------------------------------

    group('setUpdateHandler', () {
      test('should invoke the callback when channel sends updateDecibel '
          'with a valid double', () async {
        // arrange
        double? receivedValue;
        repository.setUpdateHandler((value) => receivedValue = value);

        // act — simulate the native side calling back into Dart
        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              ValueConstant.pathChannel,
              channel.codec.encodeMethodCall(
                const MethodCall('updateDecibel', 72.5),
              ),
              (_) {},
            );

        // assert
        expect(receivedValue, equals(72.5));
      });

      test('should not invoke the callback when channel sends updateDecibel '
          'with a null argument', () async {
        // arrange
        bool callbackInvoked = false;
        repository.setUpdateHandler((_) => callbackInvoked = true);

        // act
        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              ValueConstant.pathChannel,
              channel.codec.encodeMethodCall(
                const MethodCall('updateDecibel', null),
              ),
              (_) {},
            );

        // assert
        expect(callbackInvoked, isFalse);
      });

      test(
        'should not invoke the callback for unrelated channel methods',
        () async {
          // arrange
          bool callbackInvoked = false;
          repository.setUpdateHandler((_) => callbackInvoked = true);

          // act
          await TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .handlePlatformMessage(
                ValueConstant.pathChannel,
                channel.codec.encodeMethodCall(
                  const MethodCall('someOtherMethod', 99.0),
                ),
                (_) {},
              );

          // assert
          expect(callbackInvoked, isFalse);
        },
      );

      test(
        'should invoke the callback multiple times for sequential updates',
        () async {
          // arrange
          final receivedValues = <double>[];
          repository.setUpdateHandler(receivedValues.add);

          // act
          for (final value in [60.0, 70.0, 80.0]) {
            await TestDefaultBinaryMessengerBinding
                .instance
                .defaultBinaryMessenger
                .handlePlatformMessage(
                  ValueConstant.pathChannel,
                  channel.codec.encodeMethodCall(
                    MethodCall('updateDecibel', value),
                  ),
                  (_) {},
                );
          }

          // assert
          expect(receivedValues, equals([60.0, 70.0, 80.0]));
        },
      );
    });
  });
}
