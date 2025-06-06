import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_audio_player_plugin_method_channel.dart';

abstract class FlutterAudioPlayerPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterAudioPlayerPluginPlatform.
  FlutterAudioPlayerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAudioPlayerPluginPlatform _instance =
      MethodChannelFlutterAudioPlayerPlugin();

  /// The default instance of [FlutterAudioPlayerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAudioPlayerPlugin].
  static FlutterAudioPlayerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAudioPlayerPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterAudioPlayerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setFilePath(String filePath) {
    throw UnimplementedError('setFilePath() has not been implemented.');
  }

  Future<void> loadAudio(String url, String title, String artist) {
    throw UnimplementedError('loadAudio() has not been implemented.');
  }

  Future<void> play(String url) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<void> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Future<void> seekTo(int position) {
    throw UnimplementedError('seekTo() has not been implemented.');
  }

  Future<int> getCurrentPosition() {
    throw UnimplementedError('getCurrentPosition() has not been implemented.');
  }

  Future<int> getDuration() {
    throw UnimplementedError('getDuration() has not been implemented.');
  }

  dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
