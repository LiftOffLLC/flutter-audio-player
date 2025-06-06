import 'dart:async';

import 'flutter_audio_player_plugin_platform_interface.dart';

class FlutterAudioPlayerPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterAudioPlayerPluginPlatform.instance.getPlatformVersion();
  }

  Future<void> setFilePath(String filePath) {
    return FlutterAudioPlayerPluginPlatform.instance.setFilePath(filePath);
  }

  Future<void> loadAudio(String url, String title, String artist) {
    return FlutterAudioPlayerPluginPlatform.instance
        .loadAudio(url, title, artist);
  }

  Future<void> play(String url) {
    return FlutterAudioPlayerPluginPlatform.instance.play(url);
  }

  Future<void> pause() {
    return FlutterAudioPlayerPluginPlatform.instance.pause();
  }

  Future<void> stop() {
    return FlutterAudioPlayerPluginPlatform.instance.stop();
  }

  Future<void> seekTo(int position) {
    return FlutterAudioPlayerPluginPlatform.instance.seekTo(position);
  }

  Future<int> getCurrentPosition() {
    return FlutterAudioPlayerPluginPlatform.instance.getCurrentPosition();
  }

  Future<int> getDuration() {
    return FlutterAudioPlayerPluginPlatform.instance.getDuration();
  }

  dispose() {}
}
