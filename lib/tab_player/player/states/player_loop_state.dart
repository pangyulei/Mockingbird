import '../../../db/entities/en_sentence.dart';

class PlayerLoopState {
  final bool isLoop;
  final int? loopIndex;
  final EnSentence? loopSentence;
  const PlayerLoopState({
    required this.loopIndex,
    required this.loopSentence,
    required this.isLoop,
  });
  PlayerLoopState copyWith({
    bool? isLoop,
    int? Function()? loopIndex,
    EnSentence? Function()? loopSentence,
  }) {
    return PlayerLoopState(
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      loopSentence: loopSentence == null ? this.loopSentence : loopSentence(),
      isLoop: isLoop ?? this.isLoop,
    );
  }
}
