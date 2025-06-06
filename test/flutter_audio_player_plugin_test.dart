// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin.dart';
// import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin_platform_interface.dart';
// import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterAudioPlayerPluginPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterAudioPlayerPluginPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterAudioPlayerPluginPlatform initialPlatform = FlutterAudioPlayerPluginPlatform.instance;

//   test('$MethodChannelFlutterAudioPlayerPlugin is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterAudioPlayerPlugin>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterAudioPlayerPlugin flutterAudioPlayerPlugin = FlutterAudioPlayerPlugin();
//     MockFlutterAudioPlayerPluginPlatform fakePlatform = MockFlutterAudioPlayerPluginPlatform();
//     FlutterAudioPlayerPluginPlatform.instance = fakePlatform;

//     expect(await flutterAudioPlayerPlugin.getPlatformVersion(), '42');
//   });
// }
