import 'package:equatable/equatable.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

class PlayerState extends Equatable {
  final bool showLoading;
  final String title;
  final List<SentenceCardState> sentenceStates;
  final int? focusedIndex;
  final bool repeat;
  final bool showEmpty;
  final bool showVolumeSlider;
  final int versionId;
  final double speed;
  final double volume;
  final bool isPlaying;
  final double? videoSliderDraggingValue;

  const PlayerState({
    required this.isPlaying,
    required this.speed,
    required this.volume,
    required this.versionId,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    required this.repeat,
    required this.showEmpty,
    required this.showLoading,
    required this.title,
    required this.sentenceStates,
    required this.focusedIndex,
  });

  const PlayerState.empty()
    : this(
        versionId: 0,
        isPlaying: false,
        speed: 1,
        volume: 1,
        showVolumeSlider: false,
        focusedIndex: null,
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
    int? versionId,
    bool? showLoading,
    String? title,
    bool? showVolumeSlider,
    List<SentenceCardState>? sentenceStates,
    int? Function()? focusedIndex,
    bool? repeat,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      versionId: versionId ?? this.versionId,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      repeat: repeat ?? this.repeat,
      showEmpty: showEmpty ?? this.showEmpty,
      showLoading: showLoading ?? this.showLoading,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
      focusedIndex: focusedIndex == null ? this.focusedIndex : focusedIndex(),
    );
  }

  PlayerState incVersion() {
    return copyWith(versionId: versionId + 1);
  }

  @override
  List<Object?> get props => [versionId];
}
