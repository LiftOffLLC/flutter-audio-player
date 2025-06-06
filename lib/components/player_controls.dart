import 'package:flutter/material.dart';

import '../models/audio_info.dart';

class PlayerControls extends StatefulWidget {
  final void Function() handlePlayPauseAudio;
  final void Function() handleStopAudio;
  final void Function() handleSeekBackward;
  final void Function() handleSeekForward;
  final void Function() handlePlayNextAudio;
  final void Function() handlePlayPreviousAudio;
  final bool isPlaying;
  final Map<String, dynamic> iconStyle;
  final Map<PlayerIcons, dynamic> customizedIcons;
  final bool isMinPlayer;

  const PlayerControls({
    super.key,
    required this.handlePlayPauseAudio,
    required this.handleStopAudio,
    required this.handleSeekBackward,
    required this.handleSeekForward,
    required this.handlePlayNextAudio,
    required this.handlePlayPreviousAudio,
    required this.isPlaying,
    this.iconStyle = const {},
    this.customizedIcons = const {},
    this.isMinPlayer = false,
  });

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  get playIcon =>
      widget.customizedIcons[PlayerIcons.playIcon] ?? Icons.play_circle_filled;
  get pauseIcon =>
      widget.customizedIcons[PlayerIcons.pauseIcon] ??
      Icons.pause_circle_filled;
  get skipPreviousIcon =>
      widget.customizedIcons[PlayerIcons.skipPreviousIcon] ??
      Icons.skip_previous;
  get skipNextIcon =>
      widget.customizedIcons[PlayerIcons.skipNextIcon] ?? Icons.skip_next;
  get replay10Icon =>
      widget.customizedIcons[PlayerIcons.replay10Icon] ?? Icons.replay_10;
  get forward10Icon =>
      widget.customizedIcons[PlayerIcons.forward10] ?? Icons.forward_10;

  void handleSeekBackward() {
    // Handle rewind 10 seconds
    widget.handleSeekBackward();
  }

  void handleSeekForward() {
    // Handle forward 10 seconds
    widget.handleSeekForward();
  }

  void handlePlayPause() {
    // Handle play/pause
    widget.handlePlayPauseAudio();
  }

  void handlePlayNextAudio() {
    // Handle play next audio
    widget.handlePlayNextAudio();
  }

  void handlePlayPreviousAudio() {
    // Handle play previous audio
    widget.handlePlayPreviousAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMinPlayer
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(skipPreviousIcon),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayPreviousAudio,
        ),
        widget.isMinPlayer
            ? Container()
            : IconButton(
                icon: Icon(replay10Icon),
                iconSize: widget.iconStyle['iconSize'] ?? 45,
                color: widget.iconStyle['color'] ?? Colors.indigo,
                onPressed: handleSeekBackward,
              ),
        IconButton(
          icon: widget.isPlaying ? Icon(pauseIcon) : Icon(playIcon),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayPause,
        ),
        widget.isMinPlayer
            ? Container()
            : IconButton(
                icon: Icon(forward10Icon),
                iconSize: widget.iconStyle['iconSize'] ?? 45,
                color: widget.iconStyle['color'] ?? Colors.indigo,
                onPressed: handleSeekForward,
              ),
        IconButton(
          icon: Icon(skipNextIcon),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayNextAudio,
        ),
      ],
    );
  }
}
