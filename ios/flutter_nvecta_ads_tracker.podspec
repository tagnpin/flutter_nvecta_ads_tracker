#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_nvecta_ads_tracker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_nvecta_ads_tracker'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for integrating NVECTAAdTrackingSDK and managing ATT and IDFA tracking with NVECTA or notifyvisitors package.'
  s.description      = <<-DESC
An optional Flutter plugin that integrates the NVECTAAdTrackingSDK to handle
App Tracking Transparency (ATT) authorization and IDFA (Identifier for
Advertisers) retrieval. This plugin is intended to be used together with the
NVECTA or NotifyVisitors Flutter SDK and is not a standalone SDK.
                       DESC
  s.homepage         = 'https://github.com/tagnpin/flutter_nvecta_ads_tracker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mohammad Ashraf Ali' => 'ashraf@nvecta.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_nvecta_ads_tracker/Sources/flutter_nvecta_ads_tracker/**/*'
  s.platform = :ios, '14.0'

  s.dependency 'Flutter'
  s.dependency 'NVECTAAdTrackingSDK', '1.0.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_nvecta_ads_tracker_privacy' => ['flutter_nvecta_ads_tracker/Sources/flutter_nvecta_ads_tracker/PrivacyInfo.xcprivacy']}
end
