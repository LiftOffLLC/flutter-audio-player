import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'flutter_audio_player_plugin_platform_interface.dart';

/// An implementation of [FlutterAudioPlayerPluginPlatform] that uses method channels.
class MethodChannelFlutterAudioPlayerPlugin
    extends FlutterAudioPlayerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_audio_player_plugin');

  // Stream controllers for various events
  final _positionController = StreamController<int>.broadcast();
  final _completionController = StreamController<void>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _nextTrackController = StreamController<void>.broadcast();
  final _previousTrackController = StreamController<void>.broadcast();
  final _statusController = StreamController<String>.broadcast();

  @override
  Stream<int> get positionStream => _positionController.stream;

  @override
  Stream<void> get completionStream => _completionController.stream;

  @override
  Stream<String> get errorStream => _errorController.stream;

  @override
  Stream<void> get nextTrackStream => _nextTrackController.stream;

  @override
  Stream<void> get previousTrackStream => _previousTrackController.stream;

  @override
  Stream<String> get statusStream => _statusController.stream;

  MethodChannelFlutterAudioPlayerPlugin() {
    methodChannel.setMethodCallHandler(_handleNativeMethodCall);
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPositionChanged':
        _positionController.add(call.arguments as int);
        break;
      case 'onPlaybackComplete':
        _completionController.add(null);
        break;
      case 'onError':
        _errorController.add(call.arguments as String);
        break;
      case 'onNextTrack':
        _nextTrackController.add(null);
        break;
      case 'onPreviousTrack':
        _previousTrackController.add(null);
        break;
      case 'onStatusChanged':
        _statusController.add(call.arguments as String);
        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setFilePath(String filePath) async {
    await methodChannel
        .invokeMethod<void>('setFilePath', {"filePath": filePath});
  }

  @override
  Future<void> loadAudio(String url, String title, String artist) async {
    await methodChannel.invokeMethod<void>(
      'loadAudio',
      {
        'url': url,
        'title': title,
        'artist': artist,
      },
    );
  }

  @override
  Future<void> play(String url) async {
    await methodChannel.invokeMethod('play', {"url": url});
  }

  @override
  Future<void> pause() async {
    await methodChannel.invokeMethod('pause');
  }

  @override
  Future<void> resume() async {
    await methodChannel.invokeMethod('resume');
  }

  @override
  Future<void> stop() async {
    await methodChannel.invokeMethod('stop');
  }

  @override
  Future<int> getCurrentPosition() async {
    final position = await methodChannel.invokeMethod('getCurrentPosition');
    return position as int;
  }

  @override
  Future<void> seekTo(int position) async {
    await methodChannel.invokeMethod('seekTo', {'position': position});
  }

  @override
  Future<int> getDuration() async {
    final duration = await methodChannel.invokeMethod('getDuration');
    return duration as int;
  }

  // // Don't forget to dispose your controllers!
  // void dispose() {
  //   _positionController.close();
  //   _completionController.close();
  //   _errorController.close();
  //   _nextTrackController.close();
  //   _previousTrackController.close();
  // }
}
