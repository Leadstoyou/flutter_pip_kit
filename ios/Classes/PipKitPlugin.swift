import Flutter
import UIKit
import AVKit

public class PipKitPlugin: NSObject, FlutterPlugin {
  var pipController: AVPictureInPictureController?
  var playerLayer: AVPlayerLayer?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pip", binaryMessenger: registrar.messenger())
    let instance = PipKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      if #available(iOS 14.0, *) {
        result(AVPictureInPictureController.isPictureInPictureSupported())
      } else {
        result(false)
      }
    case "attachIosVideoUrl":
      guard let args = call.arguments as? [String: Any], let urlStr = args["url"] as? String, let url = URL(string: urlStr) else {
        result(FlutterError(code: "INVALID", message: "Missing url", details: nil)); return
      }
      let player = AVPlayer(url: url)
      let layer = AVPlayerLayer(player: player)
      self.playerLayer = layer
      if #available(iOS 14.0, *) {
        self.pipController = AVPictureInPictureController(playerLayer: layer)
      }
      player.play()
      result(nil)
    case "enter":
      if #available(iOS 14.0, *), let pip = self.pipController {
        pip.startPictureInPicture()
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "PiP not supported or not attached", details: nil))
      }
    case "exit":
      if #available(iOS 14.0, *), let pip = self.pipController {
        pip.stopPictureInPicture()
        result(nil)
      } else {
        result(FlutterError(code: "UNSUPPORTED", message: "PiP not supported or not attached", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
