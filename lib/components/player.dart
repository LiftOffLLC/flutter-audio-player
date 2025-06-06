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

  const Player({
    super.key,
    required this.audioInfo,
    this.iconStyle = const {},
    this.customizedIcons = const {},
  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final MethodChannelFlutterAudioPlayerPlugin _audioPlayer =
      MethodChannelFlutterAudioPlayerPlugin();
  bool _isPlaying = false;
  int _currentPosition = 0;
  int _totalDuration = 0;
  bool _isDragging = false;
  // ignore: unused_field
  String _status = '';
  StreamSubscription? _positionSubscription;
  StreamSubscription? _completionSubscription;
  StreamSubscription? _errorSubscription;
  // StreamSubscription? _nextTrackSubscription;
  // StreamSubscription? _previousTrackSubscription;

  String get audioUrl => widget.audioInfo.audioUrl ?? '';
  String get audioTitle => widget.audioInfo.title ?? '';
  String get audioPicture => widget.audioInfo.picture ?? '';
  String get audioArtist => widget.audioInfo.artist ?? '';

  @override
  void initState() {
    super.initState();
    _setFilePath();
    _setupListeners();
    _loadAudio();
  }

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
    });

    _completionSubscription = _audioPlayer.completionStream.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0;
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

  // void _playNextTrack() {
  //   // Implement next track logic
  //   print('Next track requested from notification');
  // }

  // void _playPreviousTrack() {
  //   // Implement previous track logic
  //   print('Previous track requested from notification');
  // }

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

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    _errorSubscription?.cancel();
    // _nextTrackSubscription?.cancel();
    // _previousTrackSubscription?.cancel();
    super.dispose();
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

  void handleStopAudio() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0;
        _status = PlayerStatus.stopped.name;
      });
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
  }

  void handlePlayPreviousAudio() async {
    // Handle play previous audio
    // await _audioPlayer.play(audioUrl);
  }

  void onSliderChanged(double value) {
    setState(() {
      _currentPosition = value.toInt();
    });
  }

  void onSliderChangeStart(double value) {
    setState(() {
      _isDragging = true;
    });
  }

  void onSliderChangeEnd(double value) async {
    setState(() {
      _isDragging = false;
      _currentPosition = value.toInt();
    });

    await _audioPlayer.seekTo(value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioImage(audioPicture: audioPicture),
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
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            activeTrackColor: Colors.indigo,
            inactiveTrackColor: Colors.indigo.withOpacity(0.2),
            thumbColor: Colors.indigo,
            overlayColor: Colors.indigo.withOpacity(0.2),
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
