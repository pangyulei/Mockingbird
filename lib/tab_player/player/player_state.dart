import 'package:video_player/video_player.dart';

class PlayerState {
  final String title;
  final bool repeat;
  final bool showVolumeSlider;
  final double? videoSliderDraggingValue;
  final int sentenceCount;
  final int positionMicro;
  final VideoPlayerController? videoController;

  const PlayerState({
    required this.videoController,
    required this.positionMicro,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.repeat,
    required this.title,
    required this.sentenceCount,
  });

  const PlayerState.empty()
    : this(
      videoController: null,
        positionMicro: 0,
        sentenceCount: 0,
        showVolumeSlider: false,
        repeat: false,
        title: '',
        videoSliderDraggingValue: null,
      );

  PlayerState copyWith({
    int? positionMicro,
    String? title,
    bool? showVolumeSlider,
    bool? repeat,
    int? sentenceCount,
    double? Function()? videoSliderDraggingValue,
    VideoPlayerController? Function()? videoController,
  }) {
    return PlayerState(
      positionMicro: positionMicro ?? this.positionMicro,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      repeat: repeat ?? this.repeat,
      title: title ?? this.title,
      videoController: videoController == null ? this.videoController : videoController(),
    );
  }
}
