import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_audio_player_plugin/flutter_audio_player_plugin_method_channel.dart';
import 'player_controls.dart';
import '../widgets/app_text.dart';
import '../widgets/audio_image.dart';
import '../models/audio_info.dart';

class Player extends StatefulWidget {
  final AudioInfo audioInfo;
  final Map<String, dynamic> iconStyle;
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
  final SliderThemeData? sliderStyles;
  final double? imageWidth;
  final double? imageHeight;

  const Player({
    super.key,
    required this.audioInfo,
    this.iconStyle = const {},
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
    this.sliderStyles,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool _isPlaying = false;
  int _currentPosition = 0;
  int _totalDuration = 0;
  bool _isDragging = false;
  String _status = PlayerStatus.idle.name;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _completionSubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _nextTrackSubscription;
  StreamSubscription? _previousTrackSubscription;
  StreamSubscription? _statusSubscription;

  String get audioUrl => widget.audioInfo.audioUrl ?? '';
  String get audioTitle => widget.audioInfo.title ?? '';
  String get audioPicture => widget.audioInfo.picture ?? '';
  String get audioArtist => widget.audioInfo.artist ?? '';
  MethodChannelFlutterAudioPlayerPlugin get _audioPlayer => widget.audioPlayer;

  @override
  void initState() {
    super.initState();
    _setFilePath();
    _setupListeners();
    _loadAudio();
  }

  @override
  void didUpdateWidget(Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioInfo.audioUrl != widget.audioInfo.audioUrl) {}
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    _errorSubscription?.cancel();
    _nextTrackSubscription?.cancel();
    _previousTrackSubscription?.cancel();
    _statusSubscription?.cancel();
    super.dispose();
  }

  // void _playNextTrack() {
  //   // Implement next track logic
  //   print('Next track requested from notification');
  // }

  // void _playPreviousTrack() {
  //   // Implement previous track logic
  //   print('Previous track requested from notification');
  // }

  void _setFilePath() async {
    await _audioPlayer.setFilePath(audioUrl);
    final totalDuration = await _audioPlayer.getDuration();
    setState(() {
      _totalDuration = totalDuration;
    });
  }

  void _setupListeners() {
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (!_isDragging) {
        setState(() {
          _currentPosition = position;
        });
      }
      widget.onPositionChanged?.call(position);
    });

    _statusSubscription = _audioPlayer.statusStream.listen((status) {
      setState(() {
        _status = status;
        _isPlaying = status == PlayerStatus.playing.name;
      });
    });

    _completionSubscription = _audioPlayer.completionStream.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0;
        _status = PlayerStatus.completed.name;
      });
      widget.onCompletion?.call();
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

  String _formatDuration(int milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double getTotalDuration() {
    return (_totalDuration / 1000).toDouble();
  }

  double getCurrentPosition() {
    final positionInSeconds = (_currentPosition / 1000);
    return positionInSeconds.toDouble();
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

  void handleStopAudio() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0;
        _status = PlayerStatus.stopped.name;
      });
      widget.onStop?.call();
    }
  }

  void handleSeekBackward() async {
    // Handle seek backward
    int currentPosition = getCurrentPosition().toInt();
    await _audioPlayer.seekTo(currentPosition - 10);
  }

  void handleSeekForward() async {
    // Handle seek forward to 10 seconds
    int currentPosition = getCurrentPosition().toInt();
    await _audioPlayer.seekTo(currentPosition + 10);
  }

  void handlePlayNextAudio() async {
    // Handle play next audio
    // await _audioPlayer.play(audioUrl);
    // widget.onPlayNext?.call(_currentPosition);
  }

  void handlePlayPreviousAudio() async {
    // Handle play previous audio
    // await _audioPlayer.play(audioUrl);
    // widget.onPlayPrevious?.call(_currentPosition);
  }

  void onSliderChanged(double value) async {
    final position = value.toInt() * 1000;
    setState(() {
      _currentPosition = position;
    });
  }

  void onSliderChangeStart(double value) {
    setState(() {
      _isDragging = true;
    });
  }

  void onSliderChangeEnd(double value) async {
    final position = value.toInt();
    setState(() {
      _isDragging = false;
      _currentPosition = position;
    });
    await _audioPlayer.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        audioPicture.isNotEmpty
            ? AudioImage(
                audioPicture: audioPicture,
                width: widget.imageWidth ?? 100.0,
                height: widget.imageHeight ?? 100.0,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 20),
        AppText(
          text: audioTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        AppText(
          text: audioArtist,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Progress slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: widget.sliderStyles?.trackHeight ?? 4.0,
            thumbShape: widget.sliderStyles?.thumbShape ??
                const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: widget.sliderStyles?.overlayShape ??
                const RoundSliderOverlayShape(overlayRadius: 16.0),
            activeTrackColor:
                widget.sliderStyles?.activeTrackColor ?? Colors.indigo,
            inactiveTrackColor: widget.sliderStyles?.inactiveTrackColor ??
                Colors.indigo.withOpacity(0.2),
            thumbColor: widget.sliderStyles?.thumbColor ?? Colors.indigo,
            overlayColor: widget.sliderStyles?.overlayColor ??
                Colors.indigo.withOpacity(0.2),
          ),
          child: Slider(
            value: getCurrentPosition(),
            min: 0.0,
            max: _totalDuration > 0 ? getTotalDuration() : 100.0,
            onChanged: onSliderChanged,
            onChangeStart: onSliderChangeStart,
            onChangeEnd: onSliderChangeEnd,
          ),
        ),
        // Time display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                _formatDuration(_totalDuration),
                style: Theme.of(context).textTheme.bodyMedium,
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
          isPlaying: _isPlaying,
          iconStyle: widget.iconStyle,
          isMinPlayer: false,
          customizedIcons: widget.customizedIcons,
        ),
      ],
    );
  }
}
