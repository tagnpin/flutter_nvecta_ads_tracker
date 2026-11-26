# Mobile Measurement Partner (MMP) – IDFA Integration for Flutter

`flutter_nvecta_ads_tracker` is an optional Flutter plugin designed to support IDFA-based mobile attribution and advertising campaign measurement when using NVECTA as your Mobile Measurement Partner (MMP) for advertising platforms such as Google Ads and Meta.

The plugin provides support for Apple's App Tracking Transparency (ATT) authorization and Identifier for Advertisers (IDFA) retrieval on iOS, subject to user authorization.

When integrated, the plugin automatically communicates the available tracking authorization state and IDFA internally to the core NVECTA SDK.

Applications that do not require IDFA-based attribution can continue using the [flutter_notifyvisitors](https://pub.dev/packages/flutter_notifyvisitors) package without integrating `flutter_nvecta_ads_tracker`.

This guide covers plugin installation, configuration, initialization, ATT authorization, IDFA behavior, and MMP configuration.

## Requirements

| Requirement              | Details                                                                               |
| ------------------------ | ------------------------------------------------------------------------------------- |
| Platform                 | iOS (Flutter application)                                                             |
| iOS                      | iOS 14.0 or later for ATT authorization                                               |
| Core Plugin              | **[flutter_notifyvisitors](https://pub.dev/packages/flutter_notifyvisitors)**         |
| Optional Tracking Plugin | **[flutter_nvecta_ads_tracker](https://pub.dev/packages/flutter_nvecta_ads_tracker)** |

> ATT authorization is available on iOS 14 and later. On unsupported iOS versions, the tracking flow continues without IDFA.

## Installation

To enable IDFA-based mobile attribution, add `flutter_nvecta_ads_tracker` to your Flutter project alongside the core `flutter_notifyvisitors` plugin.

```bash
flutter pub add flutter_nvecta_ads_tracker
```

The dependency configuration is:

```text
Flutter Application
├── flutter_notifyvisitors (Required)
└── flutter_nvecta_ads_tracker (Optional)
```

`flutter_nvecta_ads_tracker` requires `flutter_notifyvisitors` to be integrated first.

## Configure ATT

To request tracking authorization, add the `NSUserTrackingUsageDescription` key to the iOS application's `ios/Runner/Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to improve analytics and personalized experiences.</string>
```

The usage description is displayed to users when the system presents the ATT authorization prompt.

Ensure that the description accurately reflects how your application uses tracking information, including advertising identifiers and mobile attribution.

> The key must be present in the host application's final `Info.plist`. Adding it only to a framework's `Info.plist` is not sufficient.

---

## Initialization

Initialize `NvectaAdsTrackerPlugin` in the iOS `AppDelegate`, immediately after initializing `flutter_notifyvisitors`.

**AppDelegate.swift**

```swift
// Initialize the core Notifyvisitors SDK.
NotifyvisitorsPlugin.nvInitialise()

// Initialize the optional tracking plugin.
NvectaAdsTrackerPlugin.shared.start()
```

`start()` initializes the native tracking manager and observes the application lifecycle. It does **not** display the ATT permission prompt.

> **Important Note**
>
> Initialize `flutter_notifyvisitors` before `flutter_nvecta_ads_tracker` to ensure the core SDK is ready to receive tracking state updates.

---

## Requesting ATT Authorization

Request ATT authorization when the application is ready to display Apple's permission prompt.

You can request authorization either from the native iOS `AppDelegate` or directly from the Flutter application.

### Option 1: From AppDelegate (Swift)

If you want to request authorization during application startup:

```swift
NvectaAdsTrackerPlugin.shared.requestTrackingAuthorization { status in
    print("requestTrackingAuthorization status: \(status)")
}
```

### Option 2: From Flutter (Dart)

Alternatively, request authorization from an appropriate screen or user interaction:

```dart
NvectaAdsTracker.shared.requestTrackingAuthorization().then(
  (nvAuthStatusData) {
    debugPrint(
      'NvectaAdsTracker requestTrackingAuthorization: $nvAuthStatusData',
    );
  },
);
```

The application controls **when** the permission request is made.

> **Recommendation:** Consider the user experience before displaying the ATT prompt immediately during application launch. You can request authorization later from an appropriate screen or user flow.

---

## ATT and IDFA Behavior

The tracking plugin handles the current ATT authorization state automatically.

| ATT Status              | SDK Behavior                           |
| ----------------------- | -------------------------------------- |
| `notDetermined`         | Waits until authorization is requested |
| `authorized`            | Retrieves the IDFA                     |
| `denied`                | No IDFA is provided                    |
| `restricted`            | No IDFA is provided                    |
| Unsupported iOS version | Continues without IDFA                 |

If the user has previously made an ATT authorization decision, the plugin reads the existing status. Apple does not display the permission prompt again after a decision has been made.

`flutter_nvecta_ads_tracker` does not block `flutter_notifyvisitors` while waiting for ATT authorization. Once authorization is available, the IDFA is propagated internally to the core SDK for subsequent processing.

---

## Mobile Measurement Partner (MMP) Configuration

After integrating `flutter_nvecta_ads_tracker`, complete the applicable advertising platform configuration to enable mobile attribution and campaign measurement with `NVECTA` as your Mobile Measurement Partner (MMP).

For detailed advertising platform configuration, refer to:

➡️ **[Set Up NVECTA as Your Mobile Measurement Partner (MMP) for Google Ads and Meta](https://www.nvecta.com/support/solutions/articles/84000399758-set-up-nvecta-as-your-mobile-measurement-partner-mmp-for-google-ads-and-meta)**

---

## Privacy Considerations

Applications using IDFA should:

1. Provide a meaningful `NSUserTrackingUsageDescription`.
2. Request ATT authorization at an appropriate point in the user experience.
3. Ensure the application's App Store privacy disclosures accurately reflect its tracking and data collection practices.

---

## Troubleshooting

### ATT permission prompt does not appear

Verify:

1. The application is running on iOS 14 or later.
2. `NSUserTrackingUsageDescription` exists in the application's `Info.plist`.
3. `NvectaAdsTrackerPlugin.shared.start()` has been called.
4. `requestTrackingAuthorization()` has been called.
5. ATT authorization has not already been determined for the application.

### IDFA is not available

An IDFA is not expected when:

- ATT authorization is denied or restricted.
- Authorization has not yet been granted.
- `NSUserTrackingUsageDescription` is missing.
- The system does not provide a valid advertising identifier.
