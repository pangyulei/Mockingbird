import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_sentence_provider.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sentence_card_provider.g.dart';

@riverpod
class SentenceCard extends _$SentenceCard implements SentenceCardNotifierITF {
  @override
  Future<SentenceCardState> build(int? id) async {
    if (id == null) return const SentenceCardState.empty();
    final sentence = await ref.watch(dbSentenceProvider(id).future);
    if (sentence == null) return const SentenceCardState.empty();
    return sentence.toCardState();
  }
}

extension on EnSentence {
  SentenceCardState toCardState() {
    String formatDuration(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
      return '$minutes:$seconds.$milliseconds';
    }

    return SentenceCardState(
      text: text,
      period: '${formatDuration(start)} - ${formatDuration(end)}',
      isPlaying: false,
    );
  }
}
