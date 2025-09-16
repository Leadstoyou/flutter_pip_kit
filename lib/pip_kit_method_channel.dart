import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pip_kit_platform_interface.dart';

/// An implementation of [PipKitPlatform] that uses method channels.
class MethodChannelPipKit extends PipKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pip_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
