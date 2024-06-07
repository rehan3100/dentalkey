import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var secureView: UIView?

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
    // No need to modify secureTextEntry property of UITextField here
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    // No need to modify secureTextEntry property of UITextField here
  }

  private func enableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      if secureView == nil {
        secureView = UIView(frame: window.bounds)
        secureView!.backgroundColor = UIColor.black
        secureView!.isUserInteractionEnabled = false
        window.addSubview(secureView!)
        print("Secure UIView added to UIWindow")
      }
    }
  }

  private func disableScreenshotRestriction() {
    if let window = UIApplication.shared.windows.first {
      secureView?.removeFromSuperview()
      secureView = nil
      print("Secure UIView removed from UIWindow")
    }
  }
}
