import 'package:flutter/material.dart';

import 'package:flutter_audio_player_plugin/components/mini_player.dart';
import 'package:flutter_audio_player_plugin/components/player.dart';
import 'package:flutter_audio_player_plugin/components/player_controls.dart';
import 'package:flutter_audio_player_plugin/models/audio_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCustomizePlayerIcons = false;
  bool _isCustomizeIconStyle = false;

  Map<String, dynamic> get customizedIconStyle => _isCustomizeIconStyle
      ? const {
          'color': Colors.black54,
          'size': 16,
        }
      : const {};

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

  void customizePlayerIcons() {
    setState(() {
      _isCustomizePlayerIcons = true;
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
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioInfo = AudioInfo(
      title: 'Audio Title',
      artist: 'Audio Artist',
      audioUrl: 'https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp4',
      picture:
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=3094&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Player(
              audioInfo: audioInfo,
              customizedIcons: customizedPlayerIcons,
              iconStyle: customizedIconStyle,
            ),
            const SizedBox(height: 16),
            _buildButton('Customize Player Icons', customizePlayerIcons),
            _buildButton('Customize icon style', customizeIconStyle),
            _buildButton('Reset all', resetAll),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiniPlayer(
              audioInfo: audioInfo,
              iconStyle: customizedIconStyle,
              customizedIcons: customizedPlayerIcons,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
