# Flutter Audio Player Plugin

A comprehensive Flutter plugin that provides customizable audio player components with support for both single audio playback and playlist management. Built with modern Flutter architecture and extensive customization options.

## Features

- 🎵 **Full Audio Player** - Complete audio player with progress slider, time display, and controls
- 🎧 **Mini Player** - Compact audio player for minimal UI footprint
- 📱 **Playlist Support** - Handle multiple audio tracks with next/previous navigation
- 🎨 **Highly Customizable** - Customize icons, colors, styles, and themes
- 🔄 **Stream-based Architecture** - Real-time position updates and status changes
- 📊 **Progress Tracking** - Visual progress slider with seek functionality
- 🎯 **Event Callbacks** - Comprehensive callback system for all player events
- 🖼️ **Audio Artwork** - Display audio artwork with customizable dimensions
- ⚡ **Performance Optimized** - Efficient state management and memory usage

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_audio_player_plugin: ^1.0.0
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin.dart';

// Initialize the audio player
final audioPlayer = MethodChannelFlutterAudioPlayerPlugin();

// Create audio info
final audioInfo = AudioInfo(
  title: 'Song Title',
  artist: 'Artist Name',
  audioUrl: 'https://example.com/audio.mp3',
  picture: 'https://example.com/artwork.jpg',
);

// Use the player widget
Player(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
)
```

## Core Components

### 1. AudioInfo Model

The data model for audio metadata:

```dart
class AudioInfo {
  final String? audioUrl;    // Audio file URL
  final String? title;       // Song title
  final String? artist;      // Artist name
  final String? picture;     // Artwork URL
}
```

### 2. Player Widget

A full-featured audio player with progress slider and complete controls.

#### Props

| Prop                | Type                                    | Required | Description                       |
| ------------------- | --------------------------------------- | -------- | --------------------------------- |
| `audioPlayer`       | `MethodChannelFlutterAudioPlayerPlugin` | ✅       | Audio player instance             |
| `audioInfo`         | `AudioInfo?`                            | ❌       | Single audio information          |
| `audiosList`        | `List<AudioInfo>?`                      | ❌       | List of audio tracks for playlist |
| `iconStyle`         | `Map<String, dynamic>`                  | ❌       | Icon styling properties           |
| `customizedIcons`   | `Map<PlayerIcons, IconData>`            | ❌       | Custom icons for controls         |
| `sliderStyles`      | `SliderThemeData?`                      | ❌       | Progress slider styling           |
| `imageWidth`        | `double?`                               | ❌       | Artwork width (default: 100.0)    |
| `imageHeight`       | `double?`                               | ❌       | Artwork height (default: 100.0)   |
| `onPlay`            | `Function()?`                           | ❌       | Play event callback               |
| `onPause`           | `Function()?`                           | ❌       | Pause event callback              |
| `onResume`          | `Function()?`                           | ❌       | Resume event callback             |
| `onStop`            | `Function()?`                           | ❌       | Stop event callback               |
| `onPlayNext`        | `Function()?`                           | ❌       | Next track event callback         |
| `onPlayPrevious`    | `Function()?`                           | ❌       | Previous track event callback     |
| `onPositionChanged` | `Function(int)?`                        | ❌       | Position change callback          |
| `onCompletion`      | `Function()?`                           | ❌       | Audio completion callback         |

#### Usage Examples

**Single Audio Player:**

```dart
Player(
  audioPlayer: audioPlayer,
  audioInfo: AudioInfo(
    title: 'My Song',
    artist: 'Artist Name',
    audioUrl: 'https://example.com/song.mp3',
    picture: 'https://example.com/artwork.jpg',
  ),
  onPlay: () => print('Audio started playing'),
  onPause: () => print('Audio paused'),
  onCompletion: () => print('Audio finished'),
)
```

**Playlist Player:**

```dart
Player(
  audioPlayer: audioPlayer,
  audiosList: [
    AudioInfo(title: 'Song 1', artist: 'Artist 1', audioUrl: 'url1'),
    AudioInfo(title: 'Song 2', artist: 'Artist 2', audioUrl: 'url2'),
    AudioInfo(title: 'Song 3', artist: 'Artist 3', audioUrl: 'url3'),
  ],
  onPlayNext: () => print('Next track'),
  onPlayPrevious: () => print('Previous track'),
)
```

### 3. MiniPlayer Widget

A compact audio player for minimal UI footprint.

#### Props

| Prop                | Type                                    | Required | Description                                |
| ------------------- | --------------------------------------- | -------- | ------------------------------------------ |
| `audioPlayer`       | `MethodChannelFlutterAudioPlayerPlugin` | ✅       | Audio player instance                      |
| `audioInfo`         | `AudioInfo?`                            | ❌       | Single audio information                   |
| `audiosList`        | `List<AudioInfo>?`                      | ❌       | List of audio tracks                       |
| `iconStyle`         | `Map<String, dynamic>`                  | ❌       | Icon styling properties                    |
| `customizedIcons`   | `Map<PlayerIcons, IconData>`            | ❌       | Custom icons                               |
| `backgroundColor`   | `Color`                                 | ❌       | Background color (default: Colors.black12) |
| `onPlay`            | `Function()?`                           | ❌       | Play event callback                        |
| `onPause`           | `Function()?`                           | ❌       | Pause event callback                       |
| `onResume`          | `Function()?`                           | ❌       | Resume event callback                      |
| `onStop`            | `Function()?`                           | ❌       | Stop event callback                        |
| `onPlayNext`        | `Function()?`                           | ❌       | Next track callback                        |
| `onPlayPrevious`    | `Function()?`                           | ❌       | Previous track callback                    |
| `onPositionChanged` | `Function(int)?`                        | ❌       | Position change callback                   |
| `onCompletion`      | `Function()?`                           | ❌       | Completion callback                        |

#### Usage Example

```dart
MiniPlayer(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
  backgroundColor: Colors.grey[200],
  onPlay: () => print('Mini player started'),
)
```

### 4. PlayerControls Widget

Reusable audio control buttons component.

#### Props

| Prop                      | Type                         | Required | Description                       |
| ------------------------- | ---------------------------- | -------- | --------------------------------- |
| `handlePlayPauseAudio`    | `Function()`                 | ✅       | Play/pause handler                |
| `handleStopAudio`         | `Function()`                 | ✅       | Stop handler                      |
| `handleSeekBackward`      | `Function()`                 | ✅       | Seek backward handler             |
| `handleSeekForward`       | `Function()`                 | ✅       | Seek forward handler              |
| `handlePlayNextAudio`     | `Function()`                 | ✅       | Next track handler                |
| `handlePlayPreviousAudio` | `Function()`                 | ✅       | Previous track handler            |
| `isPlaying`               | `bool`                       | ✅       | Current playing state             |
| `iconStyle`               | `Map<String, dynamic>`       | ❌       | Icon styling                      |
| `customizedIcons`         | `Map<PlayerIcons, IconData>` | ❌       | Custom icons                      |
| `isMinPlayer`             | `bool`                       | ❌       | Mini player mode (default: false) |

### 5. AudioImage Widget

Displays audio artwork with customizable properties.

#### Props

| Prop           | Type        | Required | Description                       |
| -------------- | ----------- | -------- | --------------------------------- |
| `audioPicture` | `String`    | ✅       | Image URL                         |
| `width`        | `double`    | ❌       | Image width (default: 700)        |
| `height`       | `double`    | ❌       | Image height (default: 200)       |
| `alignment`    | `Alignment` | ❌       | Image alignment (default: center) |
| `fit`          | `BoxFit`    | ❌       | Image fit (default: contain)      |

### 6. AppText Widget

Customizable text widget with default styling.

#### Props

| Prop    | Type        | Required | Description                       |
| ------- | ----------- | -------- | --------------------------------- |
| `text`  | `String`    | ✅       | Text content                      |
| `style` | `TextStyle` | ❌       | Text styling (default: 18px bold) |

## Customization

### Icon Customization

```dart
Map<PlayerIcons, IconData> customIcons = {
  PlayerIcons.playIcon: Icons.play_arrow_outlined,
  PlayerIcons.pauseIcon: Icons.pause_outlined,
  PlayerIcons.skipPreviousIcon: Icons.skip_previous_outlined,
  PlayerIcons.skipNextIcon: Icons.skip_next_outlined,
  PlayerIcons.replay10Icon: Icons.replay_10_outlined,
  PlayerIcons.forward10: Icons.forward_10_outlined,
};

Player(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
  customizedIcons: customIcons,
)
```

### Icon Style Customization

```dart
Map<String, dynamic> iconStyle = {
  'color': Colors.blue,
  'iconSize': 45,
};

Player(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
  iconStyle: iconStyle,
)
```

### Slider Customization

```dart
SliderThemeData sliderTheme = SliderThemeData(
  trackHeight: 10.0,
  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
  activeTrackColor: Colors.tealAccent,
  inactiveTrackColor: Colors.greenAccent,
  thumbColor: Colors.limeAccent,
);

Player(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
  sliderStyles: sliderTheme,
)
```

## Player Status

The plugin provides various player statuses through the `PlayerStatus` enum:

- `loading` - Audio is loading
- `playing` - Audio is currently playing
- `paused` - Audio is paused
- `stopped` - Audio is stopped
- `error` - An error occurred
- `completed` - Audio playback completed
- `idle` - Player is idle
- `ready` - Player is ready to play

## Event Callbacks

All player components support comprehensive event callbacks:

```dart
Player(
  audioPlayer: audioPlayer,
  audioInfo: audioInfo,
  onPlay: () => print('Audio started'),
  onPause: () => print('Audio paused'),
  onResume: () => print('Audio resumed'),
  onStop: () => print('Audio stopped'),
  onPlayNext: () => print('Next track'),
  onPlayPrevious: () => print('Previous track'),
  onPositionChanged: (position) => print('Position: $position'),
  onCompletion: () => print('Audio completed'),
)
```

## Example App

The `example/` folder contains a complete demonstration app showcasing:

- Basic player usage
- Playlist functionality
- Custom icon implementation
- Style customization
- Mini player usage
- Event handling

To run the example:

```bash
cd example
flutter pub get
flutter run
```

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web (with limitations)

## Dependencies

- Flutter SDK: `>=3.3.0`
- Dart SDK: `^3.5.4`
- plugin_platform_interface: `^2.0.2`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please:

1. Check the [example app](example/) for usage patterns
2. Review the [documentation](#core-components) above
3. Open an issue on GitHub with detailed information about your problem

---

**Note**: This plugin requires proper audio permissions on Android and iOS. Make sure to add the necessary permissions to your app's manifest files.
