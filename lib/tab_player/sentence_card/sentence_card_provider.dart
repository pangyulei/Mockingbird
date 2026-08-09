import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/providers/db_sentence_provider.dart';
import 'package:mockingbird/db/providers/db_subtitle_list_provider.dart';
import 'package:mockingbird/tab_player/player/providers/player_spot_provider.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sentence_card_provider.g.dart';

@riverpod
class SentenceCard extends _$SentenceCard {
  @override
  SentenceCardState build(String id) {
    final sentence = ref.watch(dbSentenceProvider(id)).value;
    if (sentence == null) return const SentenceCardState.empty();
    final playingSentenceId = ref.watch(
      playerSpotProvider.select((st) => st.value?.playingSentence?.id),
    );
    return SentenceCardState(
      text: sentence.text,
      period: '${sentence.start.timeString} - ${sentence.end.timeString}',
      playing: sentence.id == playingSentenceId,
    );
  }
}

extension on Duration {
  String get timeString {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
