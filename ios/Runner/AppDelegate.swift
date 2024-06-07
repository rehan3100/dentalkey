import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var field: UITextField!

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
        print("enableScreenshotRestriction called")
        result(nil)
      case "disableScreenshotRestriction":
        self.disableScreenshotRestriction()
        print("disableScreenshotRestriction called")
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    self.addSecureView()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    field?.isSecureTextEntry = false
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    field?.isSecureTextEntry = true
  }

  private func addSecureView() {
    field = UITextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.isSecureTextEntry = true
    if let window = UIApplication.shared.windows.first {
      if !window.subviews.contains(field) {
        window.addSubview(field)
        field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        window.layer.superlayer?.addSublayer(field.layer)
        if #available(iOS 17.0, *) {
          field.layer.sublayers?.last?.addSublayer(window.layer)
        } else {
          field.layer.sublayers?.first?.addSublayer(window.layer)
        }
      }
    }
  }

  private func enableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      addSecureView()
    }
  }

  private func disableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      for subview in window.subviews {
        if subview is UITextField && (subview as! UITextField).isSecureTextEntry {
          subview.removeFromSuperview()
        }
      }
    }
  }
}