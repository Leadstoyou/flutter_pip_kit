import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pip_kit_method_channel.dart';

abstract class PipKitPlatform extends PlatformInterface {
  /// Constructs a PipKitPlatform.
  PipKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static PipKitPlatform _instance = MethodChannelPipKit();

  /// The default instance of [PipKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelPipKit].
  static PipKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PipKitPlatform] when
  /// they register themselves.
  static set instance(PipKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
