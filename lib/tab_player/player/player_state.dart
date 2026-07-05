import 'package:equatable/equatable.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:video_player/video_player.dart';

class PlayerState extends Equatable {
  final bool showLoading;
  final String title;
  final List<SentenceCardState> sentenceStates;
  final int? focusedIndex;
  final int? repeatIndex;
  final bool showEmpty;
  final bool showVolumeSlider;
  // final bool isPlaying;
  // final double speed;
  // final double volume;
  final int versionId;
  final VideoPlayerController? videoController;
  final double? videoSliderDraggingValue;

  const PlayerState({
    required this.versionId,
    required this.videoController,
    required this.showVolumeSlider,
    required this.videoSliderDraggingValue,
    // required this.speed,
    // required this.isPlaying,
    required this.repeatIndex,
    required this.showEmpty,
    required this.showLoading,
    required this.title,
    required this.sentenceStates,
    required this.focusedIndex,
    // required this.volume,
  });

  const PlayerState.empty()
    : this(
        versionId: 0,
        videoController: null,
        showVolumeSlider: false,
        // volume: 1,
        // isPlaying: false,
        focusedIndex: null,
        repeatIndex: null,
        sentenceStates: const [],
        showEmpty: false,
        showLoading: false,
        title: '',
        // speed: 1.0,
        videoSliderDraggingValue: null,
      );

  PlayerState copyWith({
    // double? volume,
    VideoPlayerController? Function()? videoController,
    bool? showEmpty,
    int? versionId,
    bool? showLoading,
    // bool? isPlaying,
    String? title,
    // double? speed,
    bool? showVolumeSlider,
    List<SentenceCardState>? sentenceStates,
    int? Function()? focusedIndex,
    int? Function()? repeatIndex,
    double? Function()? videoSliderDraggingValue,
  }) {
    return PlayerState(
      versionId: versionId ?? this.versionId,
      videoController: videoController == null
          ? this.videoController
          : videoController(),
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      videoSliderDraggingValue: videoSliderDraggingValue == null
          ? this.videoSliderDraggingValue
          : videoSliderDraggingValue(),
      // speed: speed ?? this.speed,
      // isPlaying: isPlaying ?? this.isPlaying,
      repeatIndex: repeatIndex == null ? this.repeatIndex : repeatIndex(),
      showEmpty: showEmpty ?? this.showEmpty,
      showLoading: showLoading ?? this.showLoading,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
      focusedIndex: focusedIndex == null ? this.focusedIndex : focusedIndex(),
      // volume: volume ?? this.volume,
    );
  }

  PlayerState incVersion() {
    return copyWith(versionId: versionId+1);
  }
  
  @override
  List<Object?> get props => [versionId];
}
