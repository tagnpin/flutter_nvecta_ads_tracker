# flutter_nvecta_ads_tracker — IDFA & App Tracking Transparency (Flutter)

`flutter_nvecta_ads_tracker` is an optional Flutter plugin that provides **App Tracking Transparency (ATT)** authorization and **IDFA (Identifier for Advertisers)** functionality for applications using the **[flutter_notifyvisitors](https://pub.dev/packages/flutter_notifyvisitors)** package.

When integrated, the tracking plugin communicates the available tracking state and IDFA internally to the core Notifyvisitors SDK. Applications that do not require IDFA can continue using **[flutter_notifyvisitors](https://pub.dev/packages/flutter_notifyvisitors)** without this plugin.

## Requirements

| Requirement     | Details                                                                               |
| --------------- | ------------------------------------------------------------------------------------- |
| iOS             | iOS 14+                                                                               |
| Core SDK        | **[flutter_notifyvisitors](https://pub.dev/packages/flutter_notifyvisitors)**         |
| Optional Plugin | **[flutter_nvecta_ads_tracker](https://pub.dev/packages/flutter_nvecta_ads_tracker)** |

> ATT authorization is available on iOS 14 and later. On unsupported iOS versions, the tracking flow continues without IDFA.

## Installation

Add `flutter_nvecta_ads_tracker` to your Flutter project:

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

Add `NSUserTrackingUsageDescription` to the iOS application's `ios/Runner/Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to improve analytics and personalized experiences.</string>
```

Use a description that accurately explains why the application requests tracking authorization.

> The key must be present in the host application's final `Info.plist`. Adding it only to a framework's `Info.plist` is not sufficient.

---

## Initialization

Initialize `NvectaAdsTrackerPlugin` in the iOS `AppDelegate`, immediately after initializing `flutter_notifyvisitors`.

**AppDelegate.swift**

```swift
NotifyvisitorsPlugin.nvInitialise()
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
