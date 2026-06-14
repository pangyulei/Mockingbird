import 'package:mockingbird/models/track.dart';
import 'package:video_player/video_player.dart';
import '../../models/subtitle_sentence.dart';

class PlayerState {
  final bool showLoading;
  final String? title;
  final VideoPlayerController? playerController;
  final List<SubtitleSentence> sentences;
  final int? currentSentenceIndex;

  const PlayerState({
    required this.showLoading,
    this.playerController,
    this.title,
    this.sentences = const [],
    this.currentSentenceIndex,
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
    List<SubtitleSentence>? sentences,
    int? currentSentenceIndex,
  }) {
    return PlayerState(
      showLoading: showLoading ?? this.showLoading,
      playerController: playerController ?? this.playerController,
      title: title ?? this.title,
      sentences: sentences ?? this.sentences,
      currentSentenceIndex: currentSentenceIndex ?? this.currentSentenceIndex,
    );
  }
}
