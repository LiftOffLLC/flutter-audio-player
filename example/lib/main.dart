import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_audio_player_plugin/components/mini_player.dart';
import 'package:flutter_audio_player_plugin/components/player.dart';
import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin_method_channel.dart';
import 'package:flutter_audio_player_plugin/models/audio_info.dart';
import 'package:flutter_audio_player_plugin_example/customized_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MethodChannelFlutterAudioPlayerPlugin audioPlayer =
      MethodChannelFlutterAudioPlayerPlugin();
  bool _isCustomizePlayerIcons = false;
  bool _isCustomizeIconStyle = false;
  bool _isCustomizeSlider = false;

  final audioInfo = AudioInfo(
    title: 'Audio Title',
    artist: 'Audio Artist',
    audioUrl: 'https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp4',
    picture:
        'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  );

  final audiosList = [
    AudioInfo(
      title: 'Audio Title 1',
      artist: 'Audio Artist 1',
      audioUrl:
          'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3',
      picture:
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    AudioInfo(
      title: 'Audio Title 2',
      artist: 'Audio Artist 2',
      audioUrl:
          'https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3',
      picture:
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    AudioInfo(
      title: 'Audio Title 3',
      artist: 'Audio Artist 3',
      audioUrl:
          'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3',
      picture:
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    AudioInfo(
      title: 'Audio Title 4',
      artist: 'Audio Artist 4',
      audioUrl:
          'https://codeskulptor-demos.commondatastorage.googleapis.com/pang/paza-moduless.mp3',
      picture:
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
  ];
  final iconStyles = [
    {
      'color': Colors.green,
      'size': 16,
    },
    {
      'color': Colors.red,
      'size': 24,
    },
    {
      'color': Colors.blue,
      'size': 32,
    },
    {
      'color': Colors.yellow,
      'size': 40,
    },
    {
      'color': Colors.purple,
      'size': 48,
    },
  ];

  Map<String, dynamic> get customizedIconStyle {
    if (_isCustomizeIconStyle) {
      // how to randomly pick one from iconStyles
      return iconStyles[Random().nextInt(iconStyles.length)];
    }
    return const {};
  }

  Map<PlayerIcons, dynamic> get customizedPlayerIcons => _isCustomizePlayerIcons
      ? const {
          PlayerIcons.playIcon: Icons.play_arrow_outlined,
          PlayerIcons.pauseIcon: Icons.pause_outlined,
          PlayerIcons.skipPreviousIcon: Icons.skip_previous_outlined,
          PlayerIcons.skipNextIcon: Icons.skip_next_outlined,
          PlayerIcons.replay10Icon: Icons.replay_10_outlined,
          PlayerIcons.forward10: Icons.forward_10_outlined,
        }
      : const {};

  SliderThemeData get customizedSliderTheme => _isCustomizeSlider
      ? const SliderThemeData(
          trackHeight: 10.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
          activeTrackColor: Colors.tealAccent,
          inactiveTrackColor: Colors.greenAccent,
          thumbColor: Colors.limeAccent,
        )
      : const SliderThemeData();

  void customizePlayerIcons() {
    setState(() {
      _isCustomizePlayerIcons = !_isCustomizePlayerIcons;
    });
  }

  void customizeIconStyle() {
    setState(() {
      _isCustomizeIconStyle = true;
    });
  }

  void resetAll() {
    setState(() {
      _isCustomizePlayerIcons = false;
      _isCustomizeIconStyle = false;
      _isCustomizeSlider = false;
    });
  }

  void customizeSlider() {
    setState(() {
      _isCustomizeSlider = true;
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
        ),
        child: Text(text, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildCustomizedPlayer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomizedPlayer(
        audioPlayer: audioPlayer,
        audioInfo: audioInfo,
        customizedIcons: customizedPlayerIcons,
        iconStyle: customizedIconStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Player(
              audioPlayer: audioPlayer,
              // audioInfo: audioInfo,
              customizedIcons: customizedPlayerIcons,
              iconStyle: customizedIconStyle,
              sliderStyles: customizedSliderTheme,
              audiosList: audiosList,
            ),
            const SizedBox(height: 16),
            _buildButton('Customize Player Icons', customizePlayerIcons),
            _buildButton('Customize icon style', customizeIconStyle),
            _buildButton('Customize Slider', customizeSlider),
            _buildButton('Reset all', resetAll),
            const SizedBox(height: 16),
            _buildCustomizedPlayer(),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiniPlayer(
              // audioInfo: audioInfo,
              iconStyle: customizedIconStyle,
              customizedIcons: customizedPlayerIcons,
              backgroundColor: Colors.grey,
              audioPlayer: audioPlayer,
              audiosList: audiosList,
            ),
          ],
        ),
      ),
    );
  }
}
