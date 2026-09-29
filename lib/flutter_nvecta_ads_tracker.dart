import 'package:flutter/services.dart';

class NvectaAdsTracker {
  static NvectaAdsTracker shared = NvectaAdsTracker();

  final MethodChannel _channel = const MethodChannel(
    'flutter_nvecta_ads_tracker',
  );

  Future<void> start() async {
    await _channel.invokeMethod('start');
  }

  Future<void> syncTrackingStatus() async {
    await _channel.invokeMethod('syncTrackingStatus');
  }

  Future<String> requestTrackingAuthorization() async {
    final String status =
        await _channel.invokeMethod<String>('requestTrackingAuthorization') ??
        'unknown';
    return status;
  }
}
