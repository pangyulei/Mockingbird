import 'package:mockingbird/tool/subtitle_parser.dart';


class PlayerLoopState {
  final bool isLoop;
  final int? loopIndex;
  final SentenceEntity? loopSentence;
  const PlayerLoopState({
    required this.loopIndex,
    required this.loopSentence,
    required this.isLoop,
  });
  PlayerLoopState copyWith({
    bool? isLoop,
    int? Function()? loopIndex,
    SentenceEntity? Function()? loopSentence,
  }) {
    return PlayerLoopState(
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      loopSentence: loopSentence == null ? this.loopSentence : loopSentence(),
      isLoop: isLoop ?? this.isLoop,
    );
  }
}
