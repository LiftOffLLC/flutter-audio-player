class AudioInfo {
  final String? audioUrl;
  final String? title;
  final String? artist;
  final String? picture;

  AudioInfo({
    this.audioUrl,
    this.title,
    this.artist,
    this.picture,
  });
}

enum PlayerStatus {
  loading,
  playing,
  paused,
  stopped,
  error,
  completed,
  idle,
  ready,
}

enum PlayerIcons {
  playIcon,
  pauseIcon,
  skipPreviousIcon,
  skipNextIcon,
  replay10Icon,
  forward10,
}
