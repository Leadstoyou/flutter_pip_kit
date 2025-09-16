
library pip_kit;

import 'dart:async';
import 'package:flutter/services.dart';

/// A Flutter plugin for Picture-in-Picture (PiP) functionality on Android and iOS.
/// 
/// This plugin provides methods to enter and exit Picture-in-Picture mode.
/// On Android, it works with any Activity that supports PiP.
/// On iOS, it requires an AVPlayerLayer (video content) to function.
class PipKit {
  static const MethodChannel _channel = MethodChannel('flutter_pip');

  /// Check if Picture-in-Picture is supported on the current device.
  /// 
  /// Returns `true` if PiP is supported, `false` otherwise.
  /// - Android: Requires API level 26+ (Android 8.0)
  /// - iOS: Requires iOS 14.0+
  static Future<bool> isSupported() async {
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Enter Picture-in-Picture mode.
  /// 
  /// [aspectX] and [aspectY] define the aspect ratio for the PiP window.
  /// Default is 16:9 ratio.
  /// 
  /// On Android: Enters PiP mode for the current Activity.
  /// On iOS: Only works if video content has been attached via [attachIosVideoUrl].
  static Future<void> enter({int aspectX = 16, int aspectY = 9}) async {
    await _channel.invokeMethod('enter', {'x': aspectX, 'y': aspectY});
  }

  /// Exit Picture-in-Picture mode.
  /// 
  /// On Android: This method has no direct effect as there's no API to programmatically exit PiP.
  /// Users need to tap the PiP window to return to the app.
  /// On iOS: Stops the PiP mode if it's currently active.
  static Future<void> exit() async {
    await _channel.invokeMethod('exit');
  }

  /// Attach video URL for iOS Picture-in-Picture functionality.
  /// 
  /// This method is iOS-specific and creates an AVPlayerLayer from the provided URL.
  /// The video will start playing automatically and can be used for PiP mode.
  /// 
  /// [url] - The video URL to play and use for PiP.
  static Future<void> attachIosVideoUrl(String url) async {
    await _channel.invokeMethod('attachIosVideoUrl', {'url': url});
  }
}
