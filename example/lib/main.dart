import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pip_kit/pip_kit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _pipSupported = false;
  bool _isInAppPip = false;
  Offset _pipPosition = const Offset(20, 100);
  ui.Image? _screenshot;
  final GlobalKey _screenKey = GlobalKey();
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

  void _toggleInAppPip() async {
    if (!_isInAppPip) {
      // Capture screen trước khi hiển thị PiP
      await _captureScreen();
    }
    setState(() {
      _isInAppPip = !_isInAppPip;
    });
  }

  void _updatePipPosition(Offset newPosition) {
    setState(() {
      _pipPosition = newPosition;
    });
  }

  Future<void> _captureScreen() async {
    try {
      RenderRepaintBoundary boundary = 
          _screenKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      setState(() {
        _screenshot = image;
      });
    } catch (e) {
      print('Error capturing screen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter PiP Example')),
        body: RepaintBoundary(
          key: _screenKey,
          child: Stack(
            children: [
              Column(
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _toggleInAppPip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isInAppPip ? Colors.red : Colors.blue,
                  ),
                  child: Text(_isInAppPip ? 'Exit In-App PiP' : 'Enter In-App PiP'),
                ),
              ],
            ),
            // In-App PiP Overlay
            if (_isInAppPip)
              Positioned(
                left: _pipPosition.dx,
                top: _pipPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _updatePipPosition(details.globalPosition);
                  },
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Screenshot display
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _screenshot != null
                                ? CustomPaint(
                                    painter: ScreenshotPainter(_screenshot!),
                                    size: const Size(200, 120),
                                  )
                                : Container(
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: _toggleInAppPip,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        // Drag handle
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.drag_handle,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScreenshotPainter extends CustomPainter {
  final ui.Image image;

  ScreenshotPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
