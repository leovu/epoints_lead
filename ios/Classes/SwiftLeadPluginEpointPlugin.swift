import Flutter
import UIKit

public class SwiftLeadPluginEpointPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lead_plugin_epoint", binaryMessenger: registrar.messenger())
    let instance = SwiftLeadPluginEpointPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
