import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:video_player/video_player.dart';

class PlayerState {
  final bool showLoading;
  final String? title;
  final VideoPlayerController? videoController;
  final List<SentenceCardState> sentenceStates;
  final int? playingSentenceIndex;
  final bool showEmpty;

  const PlayerState({
    this.showEmpty = false,
    this.showLoading = false,
    this.videoController,
    this.title,
    this.sentenceStates = const [],
    this.playingSentenceIndex,
  });

  PlayerState copyWith({
    bool? showEmpty,
    bool? showLoading,
    VideoPlayerController? videoController,
    String? title,
    List<SentenceCardState>? sentenceStates,
    int? playingSentenceIndex,
  }) {
    return PlayerState(
      showEmpty: showEmpty ?? this.showEmpty,
      showLoading: showLoading ?? this.showLoading,
      videoController: videoController ?? this.videoController,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
      playingSentenceIndex: playingSentenceIndex ?? this.playingSentenceIndex,
    );
  }
}
