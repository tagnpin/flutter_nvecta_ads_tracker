import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nvecta_ads_tracker/flutter_nvecta_ads_tracker.dart';
import 'package:flutter_nvecta_ads_tracker/flutter_nvecta_ads_tracker_platform_interface.dart';
import 'package:flutter_nvecta_ads_tracker/flutter_nvecta_ads_tracker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNvectaAdsTrackerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNvectaAdsTrackerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterNvectaAdsTrackerPlatform initialPlatform = FlutterNvectaAdsTrackerPlatform.instance;

  test('$MethodChannelFlutterNvectaAdsTracker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNvectaAdsTracker>());
  });

  test('getPlatformVersion', () async {
    FlutterNvectaAdsTracker flutterNvectaAdsTrackerPlugin = FlutterNvectaAdsTracker();
    MockFlutterNvectaAdsTrackerPlatform fakePlatform = MockFlutterNvectaAdsTrackerPlatform();
    FlutterNvectaAdsTrackerPlatform.instance = fakePlatform;

    expect(await flutterNvectaAdsTrackerPlugin.getPlatformVersion(), '42');
  });
}
