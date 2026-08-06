import 'package:mockingbird/tool/subtitle_parser.dart';

class PlayerSpotState {
  final int? playingSentenceIndex;
  final SentenceEntity? playingSentence;

  const PlayerSpotState({
    required this.playingSentenceIndex,
    required this.playingSentence,
  });

  PlayerSpotState copyWith({
    SentenceEntity? Function()? playingSentence,
    int? Function()? playingSentenceIndex,
  }) {
    return PlayerSpotState(
      playingSentenceIndex: playingSentenceIndex == null
          ? this.playingSentenceIndex
          : playingSentenceIndex(),
      playingSentence: playingSentence == null
          ? this.playingSentence
          : playingSentence(),
    );
  }
}
