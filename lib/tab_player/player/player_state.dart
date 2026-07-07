import 'package:equatable/equatable.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

class PlayerState {
  final bool showLoading;
  final String title;
  final List<SentenceCardState> sentenceStates;
  final bool repeat;
  final bool showEmpty;
  final bool showVolumeSlider;
  final double speed;
  final double volume;
  final bool isPlaying;
  final double? videoSliderDraggingValue;

  const PlayerState({
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.repeat,
    required this.showEmpty,
    required this.showLoading,
    required this.title,
    required this.sentenceStates,
  });

  const PlayerState.empty()
    : this(
        isPlaying: false,
        speed: 1,
        volume: 1,
        showVolumeSlider: false,
        repeat: false,
        sentenceStates: const [],
        showEmpty: false,
        showLoading: false,
        title: '',
        videoSliderDraggingValue: null,
      );

  PlayerState copyWith({
    bool? isPlaying,
    double? speed,
    double? volume,
    bool? showEmpty,
    bool? showLoading,
    String? title,
    bool? showVolumeSlider,
    List<SentenceCardState>? sentenceStates,
    bool? repeat,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      repeat: repeat ?? this.repeat,
      showEmpty: showEmpty ?? this.showEmpty,
      showLoading: showLoading ?? this.showLoading,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
    );
  }

}
