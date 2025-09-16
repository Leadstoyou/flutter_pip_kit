import 'package:flutter_test/flutter_test.dart';
import 'package:pip_kit/pip_kit.dart';
import 'package:pip_kit/pip_kit_platform_interface.dart';
import 'package:pip_kit/pip_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPipKitPlatform
    with MockPlatformInterfaceMixin
    implements PipKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PipKitPlatform initialPlatform = PipKitPlatform.instance;

  test('$MethodChannelPipKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPipKit>());
  });

  test('getPlatformVersion', () async {
    PipKit pipKitPlugin = PipKit();
    MockPipKitPlatform fakePlatform = MockPipKitPlatform();
    PipKitPlatform.instance = fakePlatform;

    expect(await pipKitPlugin.getPlatformVersion(), '42');
  });
}
