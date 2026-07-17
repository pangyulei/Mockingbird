class VideoState {
  final bool repeat;
  final bool showVolumeSlider;
  final double? videoSliderDraggingValue;
  final double speed;
  final double volume;
  final String videoPath;
  final bool isPlaying;

  const VideoState({
    required this.repeat,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.speed,
    required this.volume,
    required this.videoPath,
    required this.isPlaying,
  });

  const VideoState.empty()
    : this(
        repeat: false,
        showVolumeSlider: false,
        videoSliderDraggingValue: null,
        speed: 1.0,
        volume: 1.0,
        videoPath: '',
        isPlaying: false,
      );

  VideoState copyWith({
    bool? repeat,
    bool? showVolumeSlider,
    double? Function()? videoSliderDraggingValue,
    int? positionMicro,
    int? durationMicro,
    double? speed,
    double? volume,
    String? videoPath,
    bool? isPlaying,
  }) {
    return VideoState(
      repeat: repeat ?? this.repeat,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      videoPath: videoPath ?? this.videoPath,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class PlayerState {
  final String title;
  final int sentenceCount;
  final VideoState? videoState;

  const PlayerState({
    required this.videoState,
    required this.title,
    required this.sentenceCount,
  });

  const PlayerState.empty()
    : this(videoState: null, title: '', sentenceCount: 0);

  PlayerState copyWith({
    String? title,
    int? sentenceCount,
    VideoState? Function()? videoState,
  }) {
    return PlayerState(
      title: title ?? this.title,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      videoState: videoState == null ? this.videoState : videoState(),
    );
  }
}
