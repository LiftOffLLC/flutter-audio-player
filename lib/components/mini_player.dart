import 'dart:async';

import 'package:flutter/material.dart';

import '../flutter_audio_player_plugin_method_channel.dart';
import '../models/audio_info.dart';
import '../widgets/app_text.dart';
import '../widgets/audio_image.dart';
import './player_controls.dart';

class MiniPlayer extends StatefulWidget {
  final AudioInfo audioInfo;
  final Map<String, dynamic> iconStyle;
  final Color backgroundColor;
  final Map<PlayerIcons, dynamic> customizedIcons;

  const MiniPlayer({
    super.key,
    required this.audioInfo,
    this.iconStyle = const {},
    this.backgroundColor = Colors.black12,
    this.customizedIcons = const {},
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final MethodChannelFlutterAudioPlayerPlugin _audioPlayer =
      MethodChannelFlutterAudioPlayerPlugin();

  bool _isPlaying = false;
  // ignore: unused_field
  String _status = '';

  StreamSubscription? _positionSubscription;
  StreamSubscription? _completionSubscription;
  StreamSubscription? _errorSubscription;

  String get audioPicture => widget.audioInfo.picture ?? '';
  String get audioTitle => widget.audioInfo.title ?? '';
  String get audioArtist => widget.audioInfo.artist ?? '';
  String get audioUrl => widget.audioInfo.audioUrl ?? '';

  @override
  void initState() {
    super.initState();
    _setFilePath();
    _setupListeners();
    _loadAudio();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadAudio() async {
    try {
      if (audioUrl.isEmpty) {
        throw Exception('Audio URL is required');
      }
      await _audioPlayer.loadAudio(
        audioUrl,
        audioTitle,
        audioArtist,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio: $e')),
        );
      }
    }
  }

  void _setupListeners() {
    _completionSubscription = _audioPlayer.completionStream.listen((_) {
      setState(() {
        _isPlaying = false;
        _status = PlayerStatus.completed.name;
      });
    });

    _errorSubscription = _audioPlayer.errorStream.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });

    // _nextTrackSubscription = _audioPlayer.nextTrackStream.listen((_) {
    //   // Handle next track from notification
    //   _playNextTrack();
    // });

    // _previousTrackSubscription = _audioPlayer.previousTrackStream.listen((_) {
    //   // Handle previous track from notification
    //   _playPreviousTrack();
    // });
  }

  void _setFilePath() async {
    await _audioPlayer.setFilePath(audioUrl);
  }

  void handlePlayAudio() {
    // Handle play audio
    _audioPlayer.play(audioUrl);
  }

  void handlePauseAudio() async {
    // Handle pause audio
    await _audioPlayer.pause();
  }

  void handlePlayPauseAudio() async {
    if (_isPlaying) {
      handlePauseAudio();
    } else {
      handlePlayAudio();
    }
    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
        _status =
            _isPlaying ? PlayerStatus.playing.name : PlayerStatus.paused.name;
      });
    }
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
            handleStopAudio: () {},
            handleSeekBackward: () {},
            handleSeekForward: () {},
            handlePlayNextAudio: () {},
            handlePlayPreviousAudio: () {},
            isPlaying: _isPlaying,
            iconStyle: widget.iconStyle,
            isMinPlayer: true,
            customizedIcons: widget.customizedIcons,
          ),
        ],
      ),
    );
  }
}
