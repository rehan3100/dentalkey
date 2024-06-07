import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var secureTextField: UITextField?

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

  private func enableScreenshotRestriction() {
    guard secureTextField == nil else { return }

    let field = UITextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.isSecureTextEntry = true
    if let window = UIApplication.shared.windows.first {
      window.addSubview(field)
      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      secureTextField = field
      print("Secure UITextField added to UIWindow")
    }
  }

  private func disableScreenshotRestriction() {
    secureTextField?.removeFromSuperview()
    secureTextField = nil
    print("Secure UITextField removed from UIWindow")
  }
}
