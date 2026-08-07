import 'package:mockingbird/tool/subtitle_parser.dart';

import '../../../db/entities/sentence_entity.dart';

class PlayerLoopState {
  final bool loop;
  final int? loopIndex;
  final SentenceEntity? loopSentence;
  const PlayerLoopState({
    required this.loopIndex,
    required this.loopSentence,
    required this.loop,
  });
  PlayerLoopState copyWith({
    bool? loop,
    int? Function()? loopIndex,
    SentenceEntity? Function()? loopSentence,
  }) {
    return PlayerLoopState(
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      loopSentence: loopSentence == null ? this.loopSentence : loopSentence(),
      loop: loop ?? this.loop,
    );
  }
}
