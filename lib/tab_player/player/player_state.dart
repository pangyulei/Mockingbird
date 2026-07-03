import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';

class PlayerState {
  final bool showLoading;
  final String title;
  final List<SentenceCardState> sentenceStates;
  final int? focusedIndex;
  final int? repeatIndex;
  final bool showEmpty;
  final bool isPlaying;
  final double speed;
  final double? videoSliderDraggingValue;

  const PlayerState({
    required this.videoSliderDraggingValue,
    required this.speed,
    required this.isPlaying,
    required this.repeatIndex,
    required this.showEmpty,
    required this.showLoading,
    required this.title,
    required this.sentenceStates,
    required this.focusedIndex,
  });

  const PlayerState.empty()
    : this(
        isPlaying: false,
        focusedIndex: null,
        repeatIndex: null,
        sentenceStates: const [],
        showEmpty: false,
        showLoading: false,
        title: '',
        speed: 1.0,
        videoSliderDraggingValue: null,
      );

  PlayerState copyWith({
    bool? showEmpty,
    bool? showLoading,
    bool? isPlaying,
    String? title,
    double? speed,
    List<SentenceCardState>? sentenceStates,
    int? Function()? focusedIndex,
    int? Function()? repeatIndex,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerState(
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      speed: speed ?? this.speed,
      isPlaying: isPlaying ?? this.isPlaying,
      repeatIndex: repeatIndex == null ? this.repeatIndex : repeatIndex(),
      showEmpty: showEmpty ?? this.showEmpty,
      showLoading: showLoading ?? this.showLoading,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
      focusedIndex: focusedIndex == null ? this.focusedIndex : focusedIndex(),
    );
  }
}
