import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var restrictScreenshotViewController: UIViewController?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appWillResignActive),
      name: UIApplication.willResignActiveNotification,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @objc func appWillResignActive() {
    if let restrictScreenshotViewController = restrictScreenshotViewController {
      let window = UIApplication.shared.windows.first { $0.isKeyWindow }
      window?.addSubview(restrictScreenshotViewController.view)
    }
  }
  
  @objc func appDidBecomeActive() {
    if let restrictScreenshotViewController = restrictScreenshotViewController {
      restrictScreenshotViewController.view.removeFromSuperview()
    }
  }
}

extension UIWindow {
  func secureApp() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}
