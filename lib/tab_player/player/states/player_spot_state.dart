import 'package:mockingbird/db/entities/en_sentence.dart';

class PlayerSpotState {
  final int? playingSentenceIndex;
  final EnSentence? playingSentence;

  const PlayerSpotState({
    required this.playingSentenceIndex,
    required this.playingSentence,
  });

  PlayerSpotState copyWith({
    EnSentence? Function()? playingSentence,
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
