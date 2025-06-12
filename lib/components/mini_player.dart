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
  final MethodChannelFlutterAudioPlayerPlugin audioPlayer;
  final Function()? onPlay;
  final Function()? onPause;
  final Function()? onResume;
  final Function()? onStop;
  final Function()? onPlayNext;
  final Function()? onPlayPrevious;
  final Function(int)? onPositionChanged;
  final Function()? onCompletion;

  const MiniPlayer({
    super.key,
    required this.audioInfo,
    this.iconStyle = const {},
    this.backgroundColor = Colors.black12,
    this.customizedIcons = const {},
    required this.audioPlayer,
    this.onPlay,
    this.onPause,
    this.onResume,
    this.onStop,
    this.onPlayNext,
    this.onPlayPrevious,
    this.onPositionChanged,
    this.onCompletion,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool _isPlaying = false;
  // ignore: unused_field
  String _status = PlayerStatus.idle.name;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _completionSubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _statusSubscription;
  String get audioPicture => widget.audioInfo.picture ?? '';
  String get audioTitle => widget.audioInfo.title ?? '';
  String get audioArtist => widget.audioInfo.artist ?? '';
  String get audioUrl => widget.audioInfo.audioUrl ?? '';
  MethodChannelFlutterAudioPlayerPlugin get _audioPlayer => widget.audioPlayer;

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
    _statusSubscription?.cancel();
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
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      widget.onPositionChanged?.call(position);
    });

    _completionSubscription = _audioPlayer.completionStream.listen((_) {
      setState(() {
        _isPlaying = false;
        _status = PlayerStatus.completed.name;
      });
      widget.onCompletion?.call();
    });

    _statusSubscription = _audioPlayer.statusStream.listen((status) {
      print('status in mini player: $status');
      setState(() {
        _status = status;
        _isPlaying = status == PlayerStatus.playing.name;
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
    widget.onPlay?.call();
  }

  void handlePauseAudio() async {
    // Handle pause audio
    await _audioPlayer.pause();
    widget.onPause?.call();
  }

  void handleResumeAudio() {
    _audioPlayer.resume();
    widget.onResume?.call();
  }

  void handlePlayPauseAudio() async {
    if ([PlayerStatus.completed.name, PlayerStatus.ready.name]
        .contains(_status)) {
      handlePlayAudio();
    } else if (_status == PlayerStatus.playing.name) {
      handlePauseAudio();
    } else if (_status == PlayerStatus.paused.name) {
      handleResumeAudio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AudioImage(
              audioPicture: audioPicture,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
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
      ),
    );
  }
}
