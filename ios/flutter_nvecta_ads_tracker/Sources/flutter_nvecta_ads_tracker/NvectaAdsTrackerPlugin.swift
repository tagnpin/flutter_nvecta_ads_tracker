import Flutter
import UIKit
import NVECTAAdTrackingSDK

@objcMembers
public final class NvectaAdsTrackerPlugin: NSObject, FlutterPlugin {
    
    private static let kNVLogTag = "[Flutter-NVECTAAdsTracker]"
    private static let kNVAdsTrackerPluginVersion = "1.0.0"
    
    @objc public static let shared = NvectaAdsTrackerPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        print("\(Self.kNVLogTag)-[INFO]: REGISTER WITH REGISTRAR !!")
        print("\(Self.kNVLogTag)-[INFO]: PLUGIN_VERSION : \(Self.kNVAdsTrackerPluginVersion) !!");
        
        let channel = FlutterMethodChannel(name: "flutter_nvecta_ads_tracker", binaryMessenger: registrar.messenger())
        let instance: NvectaAdsTrackerPlugin = NvectaAdsTrackerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            start()
            result(nil)
        case "syncTrackingStatus":
            syncTrackingStatus()
            result(nil)
        case "requestTrackingAuthorization":
            requestTrackingAuthorization(result: result)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Public Native APIs
    
    @objc(start)
    public func start() {
        // Implement the logic to start tracking here
        print("\(Self.kNVLogTag)-[INFO]: Tracker started.")
        NVECTAAdTrackingManager.shared.start()
    }
    
    @objc(syncTrackingStatus)
    public func syncTrackingStatus() {
        // Implement the logic to sync tracking status here
        print("\(Self.kNVLogTag)-[INFO]: Tracking status synced.")
        NVECTAAdTrackingManager.shared.syncTrackingStatus()
    }
    
    @objc(requestTrackingAuthorization:)
    public func requestTrackingAuthorization( result: @escaping FlutterResult ) {
        print( "\(Self.kNVLogTag)-[INFO]: Tracking authorization requested." )
        NVECTAAdTrackingManager.shared.requestTrackingAuthorization { status in
            
            result(self.convertAuthorizationStatus(status))
        }
    }
    
    // MARK: - Private
    
    private func convertAuthorizationStatus(_ status: NVECTATrackingAuthorizationStatus) -> String {
        
        switch status {
            
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        case .unsupported:
            return "unsupported"
        }
    }
}
