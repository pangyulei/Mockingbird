import 'package:video_player/video_player.dart';

class PlayerVideoState {
  final bool repeat;
  final bool showVolumeSlider;
  final double? videoSliderDraggingValue;
  final VideoPlayerController controller;

  const PlayerVideoState({
    required this.repeat,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.controller,
  });

  double get speed => controller.value.playbackSpeed;
  double get volume => controller.value.volume;
  bool get isPlaying => controller.value.isPlaying;

  PlayerVideoState copyWith({
    bool? repeat,
    bool? showVolumeSlider,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerVideoState(
      controller: controller,
      repeat: repeat ?? this.repeat,
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
