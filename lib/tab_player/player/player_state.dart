import 'package:video_player/video_player.dart';

class PlayerVideoState {
  final bool repeat;
  final bool showVolumeSlider;
  final double? videoSliderDraggingValue;
  final VideoPlayerController controller;
  final bool isPlaying;
  final double speed;
  final double volume;

  const PlayerVideoState({
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.repeat,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.controller,
  });

  PlayerVideoState copyWith({
    bool? repeat,
    bool? isPlaying,
    double? speed,
    double? volume,
    bool? showVolumeSlider,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerVideoState(
      controller: controller,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      repeat: repeat ?? this.repeat,
      isPlaying: isPlaying ?? this.isPlaying,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
    );
  }
}

class PlayerState {
  final String title;
  final int sentenceCount;
  final PlayerVideoState? videoState;

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
    PlayerVideoState? Function()? videoState,
  }) {
    return PlayerState(
      title: title ?? this.title,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      videoState: videoState == null ? this.videoState : videoState(),
    );
  }
}
