import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:video_player/video_player.dart';

class PlayerState {
  final bool showLoading;
  final String? title;
  final VideoPlayerController? playerController;
  final List<SentenceCardState> sentenceStates;
  final int? playingSentenceIndex;

  const PlayerState({
    this.showLoading = false,
    this.playerController,
    this.title,
    this.sentenceStates = const [],
    this.playingSentenceIndex,
  });

  bool get showEmpty {
    return title == null ||
        playerController == null ||
        playerController!.value.isInitialized == false;
  }

  PlayerState copyWith({
    bool? showLoading,
    VideoPlayerController? playerController,
    String? title,
    List<SentenceCardState>? sentenceStates,
    int? playingSentenceIndex,
  }) {
    return PlayerState(
      showLoading: showLoading ?? this.showLoading,
      playerController: playerController ?? this.playerController,
      title: title ?? this.title,
      sentenceStates: sentenceStates ?? this.sentenceStates,
      playingSentenceIndex: playingSentenceIndex ?? this.playingSentenceIndex,
    );
  }
}
