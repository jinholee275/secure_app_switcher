import Flutter
import UIKit

public class SwiftSecureAppSwitcherPlugin: NSObject, FlutterPlugin {
  var secureField : UITextField?

  enum SecureMaskStyle: Int {
    case light = 0
    case dark = 1
    case blurLight = 2
    case blurDark = 3
  }

  func createSecureView(styleIdx: Int? = nil) -> UIView {
    var secureView: UIView

    switch styleIdx {
    case SecureMaskStyle.light.rawValue:
      secureView = UIView(frame: CGRect(x: 0, y: 0, width: secureField!.frame.self.width, height: secureField!.frame.self.height))
      secureView.backgroundColor = UIColor.white
    case SecureMaskStyle.dark.rawValue:
      secureView = UIView(frame: CGRect(x: 0, y: 0, width: secureField!.frame.self.width, height: secureField!.frame.self.height))
      secureView.backgroundColor = UIColor.black
    case SecureMaskStyle.blurLight.rawValue:
      secureView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    case SecureMaskStyle.blurDark.rawValue:
      secureView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    default:
      secureView = UIView(frame: CGRect(x: 0, y: 0, width: secureField!.frame.self.width, height: secureField!.frame.self.height))
      secureView.backgroundColor = UIColor.white
    }

    return secureView
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "secure_app_switcher", binaryMessenger: registrar.messenger())
    let instance = SwiftSecureAppSwitcherPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "on":
      setSecureField()
      if let args = call.arguments as? [String: Any], let style = args["style"] as? Int {
        secureField?.leftView = createSecureView(styleIdx: style)
        secureField?.isSecureTextEntry = true
      }
      result(nil)
    case "off":
      secureField?.isSecureTextEntry = false
      result(nil)
    default:
      secureField?.isSecureTextEntry = false
      result(FlutterMethodNotImplemented)
    }
  }

  private func setSecureField() {
    if let window = UIApplication.shared.windows.first {
      if secureField != nil { return }

      secureField = UITextField()
      window.addSubview(secureField!)
      window.layer.superlayer?.addSublayer(secureField!.layer)
      secureField!.layer.sublayers?.last!.addSublayer(window.layer)
      secureField!.leftViewMode = .always
    }
  }

  //  public func applicationDidBecomeActive(_ application: UIApplication) {
  //    self.secureView?.removeFromSuperview()
  //  }
  //
  //  public func applicationWillResignActive(_ application: UIApplication) {
  //    if let window = UIApplication.shared.windows.first, let view = secureView {
  //      view.frame = window.bounds
  //      window.addSubview(view)
  //    }
  //  }
}
