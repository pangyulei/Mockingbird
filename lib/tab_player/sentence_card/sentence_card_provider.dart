import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/providers/db_sentence_provider.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../player/providers/player_spot_provider.dart';

part 'sentence_card_provider.g.dart';

@riverpod
class SentenceCard extends _$SentenceCard {
  
  //not return Future<T>, fix playerui sentencelist can't scroll bug
  @override
  SentenceCardState build(int? id) {
    final EnSentence? sentence = ref.watch(dbSentenceProvider(id).select((st)=>st.value));
    if (sentence == null) return const SentenceCardState.empty();
    final int? playingSentenceId = ref.watch(
      playerSpotProvider.select((st) => st.value?.playingSentence?.id),
    );
    String formatDuration(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
      return '$minutes:$seconds.$milliseconds';
    }

    return SentenceCardState(
      text: sentence.text,
      period:
          '${formatDuration(sentence.start)} - ${formatDuration(sentence.end)}',
      isPlaying: sentence.id == playingSentenceId,
    );
  }
}
