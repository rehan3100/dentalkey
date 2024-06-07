import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var field: UITextField?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.dentalkeybyrehan.dentalkey/screenshot", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      switch call.method {
      case "enableScreenshotRestriction":
        self.enableScreenshotRestriction()
        result(nil)
      case "disableScreenshotRestriction":
        self.disableScreenshotRestriction()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    field?.isSecureTextEntry = false
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    field?.isSecureTextEntry = true
  }

  private func enableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      if field == nil {
        field = UITextField()
        field!.translatesAutoresizingMaskIntoConstraints = false
        field!.isSecureTextEntry = true
        window.addSubview(field!)
        field!.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field!.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        window.layer.superlayer?.addSublayer(field!.layer)
        if #available(iOS 17.0, *) {
          field!.layer.sublayers?.last?.addSublayer(window.layer)
        } else {
          field!.layer.sublayers?.first?.addSublayer(window.layer)
        }
        print("Secure UITextField added to UIWindow")
      }
    }
  }

  private func disableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      if let secureField = field {
        secureField.removeFromSuperview()
        field = nil
        print("Secure UITextField removed from UIWindow")
      }
    }
  }
}
