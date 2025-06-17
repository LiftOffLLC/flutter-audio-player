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

  Future<void> resume() {
    return FlutterAudioPlayerPluginPlatform.instance.resume();
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

  Stream<String> get statusStream {
    return FlutterAudioPlayerPluginPlatform.instance.statusStream;
  }

  Stream<int> get positionStream {
    return FlutterAudioPlayerPluginPlatform.instance.positionStream;
  }

  Stream<void> get completionStream {
    return FlutterAudioPlayerPluginPlatform.instance.completionStream;
  }

  Stream<String> get errorStream {
    return FlutterAudioPlayerPluginPlatform.instance.errorStream;
  }

  Stream<void> get nextTrackStream {
    return FlutterAudioPlayerPluginPlatform.instance.nextTrackStream;
  }

  Stream<void> get previousTrackStream {
    return FlutterAudioPlayerPluginPlatform.instance.previousTrackStream;
  }

  Future<void> playNext(int nextIndex) {
    return FlutterAudioPlayerPluginPlatform.instance.playNext(nextIndex);
  }

  Future<void> playPrevious(int previousIndex) {
    return FlutterAudioPlayerPluginPlatform.instance
        .playPrevious(previousIndex);
  }

  dispose() {}
}
