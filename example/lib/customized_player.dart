import 'package:flutter/material.dart';
import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin_method_channel.dart';
import 'package:flutter_audio_player_plugin/models/audio_info.dart';

class CustomizedPlayer extends StatefulWidget {
  final MethodChannelFlutterAudioPlayerPlugin audioPlayer;
  final AudioInfo audioInfo;
  final Map<PlayerIcons, dynamic> customizedIcons;
  final Map<String, dynamic> iconStyle;
  const CustomizedPlayer({
    super.key,
    required this.audioPlayer,
    required this.audioInfo,
    required this.customizedIcons,
    required this.iconStyle,
  });

  @override
  State<CustomizedPlayer> createState() => _CustomizedPlayerState();
}

class _CustomizedPlayerState extends State<CustomizedPlayer> {
  bool _isPlaying = false;
  get _audioPlayer => widget.audioPlayer;
  get _audioInfo => widget.audioInfo;
  // get _customizedIcons => widget.customizedIcons;
  // get _iconStyle => widget.iconStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _audioPlayer.stop();
              setState(() {
                _isPlaying = false;
              });
            },
            icon: const Icon(Icons.stop),
          ),
          _isPlaying
              ? IconButton(
                  onPressed: () {
                    _audioPlayer.pause();
                    setState(() {
                      _isPlaying = false;
                    });
                  },
                  icon: const Icon(Icons.pause),
                )
              : IconButton(
                  onPressed: () {
                    _audioPlayer.play(_audioInfo.audioUrl);
                    setState(() {
                      _isPlaying = true;
                    });
                  },
                  icon: const Icon(Icons.play_arrow),
                ),
        ],
      ),
    );
  }
}
