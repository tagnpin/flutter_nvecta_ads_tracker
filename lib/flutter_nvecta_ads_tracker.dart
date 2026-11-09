import 'package:flutter/services.dart';

/// Provides access to the NVECTA iOS advertising tracking functionality.
///
/// This package is an optional companion package for the NVECTA or
/// NotifyVisitors Flutter SDK and is available on iOS only.
///
/// The underlying native implementation uses `NVECTAAdTrackingSDK` to
/// manage App Tracking Transparency (ATT) authorization and IDFA tracking.

class NvectaAdsTracker {
  /// The shared singleton instance of [NvectaAdsTracker].
  static NvectaAdsTracker shared = NvectaAdsTracker();

  final MethodChannel _channel = const MethodChannel(
    'flutter_nvecta_ads_tracker',
  );

  /// Starts the native advertising tracking SDK.
  ///
  /// This method initializes the underlying native tracking manager.
  Future<void> start() async {
    await _channel.invokeMethod('start');
  }

  /// Synchronizes the current tracking authorization status with the
  /// underlying native SDK.
  Future<void> syncTrackingStatus() async {
    await _channel.invokeMethod('syncTrackingStatus');
  }

  /// Requests App Tracking Transparency authorization from the user.
  ///
  /// Returns the authorization status reported by the native iOS SDK.
  ///
  /// This method is supported only on iOS.
  Future<String> requestTrackingAuthorization() async {
    final String status =
        await _channel.invokeMethod<String>('requestTrackingAuthorization') ??
        'unknown';
    return status;
  }
}
