import 'package:flutter/material.dart';
import 'package:pip_kit/pip_kit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _pipSupported = false;
  final String videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  void initState() {
    super.initState();
    _checkPip();
    _attachIos();
  }

  Future<void> _checkPip() async {
    final ok = await PipKit.isSupported();
    setState(() => _pipSupported = ok);
  }

  Future<void> _attachIos() async {
    // iOS: attach video url để plugin native tạo AVPlayerLayer
    try {
      await PipKit.attachIosVideoUrl(videoUrl);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter PiP Example')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_library, size: 100),
            const SizedBox(height: 24),
            Text(
              'PiP Supported: $_pipSupported',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pipSupported
                      ? () => PipKit.enter(aspectX: 16, aspectY: 9)
                      : null,
                  child: const Text('Enter PiP'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pipSupported ? () => PipKit.exit() : null,
                  child: const Text('Exit PiP'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _attachIos(),
              child: const Text('Attach Video (iOS)'),
            ),
          ],
        ),
      ),
    );
  }
}
