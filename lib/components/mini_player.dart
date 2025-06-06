import 'package:flutter/material.dart';

import '../models/audio_info.dart';
import '../widgets/app_text.dart';
import '../widgets/audio_image.dart';
import './player_controls.dart';

class MiniPlayer extends StatefulWidget {
  final AudioInfo audioInfo;
  final Map<String, dynamic> iconStyle;
  final Color backgroundColor;

  const MiniPlayer({
    super.key,
    required this.audioInfo,
    this.iconStyle = const {},
    this.backgroundColor = Colors.black12,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  String get audioPicture => widget.audioInfo.picture ?? '';
  String get audioTitle => widget.audioInfo.title ?? '';
  String get audioArtist => widget.audioInfo.artist ?? '';

  bool isPlaying = false;

  void handlePlayPauseAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void handleStopAudio() {
    setState(() {
      isPlaying = false;
    });
  }

  void handleSeekBackward() {
    setState(() {
      isPlaying = false;
    });
  }

  void handlePlayNextAudio() {
    setState(() {
      isPlaying = false;
    });
  }

  void handlePlayPreviousAudio() {
    setState(() {
      isPlaying = false;
    });
  }

  void handleSeekForward() {
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: AudioImage(
              audioPicture: audioPicture,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: audioTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppText(
                  text: audioArtist,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PlayerControls(
            handlePlayPauseAudio: handlePlayPauseAudio,
            handleStopAudio: handleStopAudio,
            handleSeekBackward: handleSeekBackward,
            handleSeekForward: handleSeekForward,
            handlePlayNextAudio: handlePlayNextAudio,
            handlePlayPreviousAudio: handlePlayPreviousAudio,
            isPlaying: isPlaying,
            iconStyle: widget.iconStyle,
            isMinPlayer: true,
          ),
        ],
      ),
    );
  }
}
