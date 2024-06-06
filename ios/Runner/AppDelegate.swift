import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var window: UIWindow?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let secureChannel = FlutterMethodChannel(name: "com.dentalkeybyrehan.secure",
                                              binaryMessenger: controller.binaryMessenger)
    
    secureChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      switch call.method {
      case "enableSecureScreen":
        self.enableSecureScreen()
        result(nil)
      case "disableSecureScreen":
        self.disableSecureScreen()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func enableSecureScreen() {
    if let window = self.window {
        let field = UITextField()
        field.isSecureTextEntry = true
        window.addSubview(field)
        field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        window.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.first?.addSublayer(window.layer)
    }
  }

  private func disableSecureScreen() {
    if let window = self.window {
        for view in window.subviews {
            if view is UITextField && (view as! UITextField).isSecureTextEntry {
                view.removeFromSuperview()
            }
        }
    }
  }
}
