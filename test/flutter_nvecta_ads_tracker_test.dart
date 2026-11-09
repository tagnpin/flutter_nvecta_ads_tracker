import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nvecta_ads_tracker/flutter_nvecta_ads_tracker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_nvecta_ads_tracker');

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);

          switch (methodCall.method) {
            case 'start':
              return null;

            case 'syncTrackingStatus':
              return null;

            case 'requestTrackingAuthorization':
              return 'authorized';

            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('FlutterNvectaAdsTracker', () {
    test('start invokes native start method', () async {
      await NvectaAdsTracker.shared.start();

      expect(log, hasLength(1));
      expect(log.first.method, 'start');
      expect(log.first.arguments, isNull);
    });

    test('syncTrackingStatus invokes native method', () async {
      await NvectaAdsTracker.shared.syncTrackingStatus();

      expect(log, hasLength(1));
      expect(log.first.method, 'syncTrackingStatus');
      expect(log.first.arguments, isNull);
    });

    test(
      'requestTrackingAuthorization returns native authorization status',
      () async {
        final dynamic status = await NvectaAdsTracker.shared
            .requestTrackingAuthorization();
        expect(status, 'authorized');
        expect(log, hasLength(1));
        expect(log.first.method, 'requestTrackingAuthorization');
        expect(log.first.arguments, isNull);
      },
    );
  });
}
