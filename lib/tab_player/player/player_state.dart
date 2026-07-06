import 'package:equatable/equatable.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:video_player/video_player.dart';

class PlayerState extends Equatable {
  final bool showLoading;
  final String title;
  final List<SentenceCardState> sentenceStates;
  final int? focusedIndex;
  final bool repeat;
  final bool showEmpty;
  final bool showVolumeSlider;
  final int versionId;
  final VideoPlayerController? videoController;
  final double? videoSliderDraggingValue;

  const PlayerState({
    required this.versionId,
    required this.videoController,
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
        videoController: null,
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
    VideoPlayerController? Function()? videoController,
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
      versionId: versionId ?? this.versionId,
      videoController: videoController == null
          ? this.videoController
          : videoController(),
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
