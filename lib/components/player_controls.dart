import 'package:flutter/material.dart';

class PlayerControls extends StatefulWidget {
  final void Function() handlePlayPauseAudio;
  final void Function() handleStopAudio;
  final void Function() handleSeekBackward;
  final void Function() handleSeekForward;
  final void Function() handlePlayNextAudio;
  final void Function() handlePlayPreviousAudio;
  final bool isPlaying;
  final Map<String, dynamic> iconStyle;
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
    this.isMinPlayer = false,
  });

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
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
          icon: const Icon(Icons.skip_previous),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayPreviousAudio,
        ),
        widget.isMinPlayer
            ? Container()
            : IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: widget.iconStyle['iconSize'] ?? 45,
                color: widget.iconStyle['color'] ?? Colors.indigo,
                onPressed: handleSeekBackward,
              ),
        IconButton(
          icon: widget.isPlaying
              ? const Icon(Icons.pause_circle_filled)
              : const Icon(Icons.play_circle_filled),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayPause,
        ),
        widget.isMinPlayer
            ? Container()
            : IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: widget.iconStyle['iconSize'] ?? 45,
                color: widget.iconStyle['color'] ?? Colors.indigo,
                onPressed: handleSeekForward,
              ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: widget.iconStyle['iconSize'] ?? 45,
          color: widget.iconStyle['color'] ?? Colors.indigo,
          onPressed: handlePlayNextAudio,
        ),
      ],
    );
  }
}
