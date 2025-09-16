# PipKit

A Flutter plugin for Picture-in-Picture (PiP) functionality on Android and iOS.

## Features

- ✅ **Android**: Enter PiP mode for any Activity (API 26+)
- ✅ **iOS**: Enter PiP mode for video content (iOS 14+)
- ✅ **Cross-platform**: Unified API for both platforms
- ✅ **Easy to use**: Simple static methods

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pip_kit: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:pip_kit/pip_kit.dart';

// Check if PiP is supported
bool isSupported = await PipKit.isSupported();

// Enter PiP mode with default 16:9 aspect ratio
await PipKit.enter();

// Enter PiP mode with custom aspect ratio
await PipKit.enter(aspectX: 4, aspectY: 3);

// Exit PiP mode (iOS only, Android users tap the window)
await PipKit.exit();
```

### iOS Video Support

For iOS, you need to attach video content before entering PiP:

```dart
// Attach video URL for iOS PiP
await PipKit.attachIosVideoUrl('https://example.com/video.mp4');

// Now you can enter PiP
await PipKit.enter();
```

## Platform Requirements

### Android
- **Minimum SDK**: API 26 (Android 8.0)
- **Manifest**: Add `android:supportsPictureInPicture="true"` to your Activity

```xml
<activity
    android:name=".MainActivity"
    android:supportsPictureInPicture="true"
    android:configChanges="orientation|screenSize|smallestScreenSize|screenLayout|keyboardHidden|keyboard">
</activity>
```

### iOS
- **Minimum Version**: iOS 14.0
- **Info.plist**: Add background audio mode (optional)

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

## Example

See the `example/` directory for a complete working example with video player integration.

## API Reference

### PipKit

#### `isSupported()`
Check if Picture-in-Picture is supported on the current device.

**Returns:** `Future<bool>`

#### `enter({int aspectX = 16, int aspectY = 9})`
Enter Picture-in-Picture mode.

**Parameters:**
- `aspectX`: Width aspect ratio (default: 16)
- `aspectY`: Height aspect ratio (default: 9)

**Returns:** `Future<void>`

#### `exit()`
Exit Picture-in-Picture mode.

**Note:** On Android, this method has no effect. Users need to tap the PiP window to return to the app.

**Returns:** `Future<void>`

#### `attachIosVideoUrl(String url)`
Attach video URL for iOS Picture-in-Picture functionality.

**Parameters:**
- `url`: The video URL to play and use for PiP

**Returns:** `Future<void>`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.