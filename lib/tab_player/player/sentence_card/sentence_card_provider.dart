import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_player/player/player_provider.dart';
import 'package:mockingbird/tab_player/player/sentence_card/sentence_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sentence_card_provider.g.dart';

@riverpod
class SentenceCard extends _$SentenceCard {
  @override
  SentenceCardState build(int? id) {
    if (id == null) return const SentenceCardState.empty();
    final EnSentence? sentence = ref.watch(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => [for (final a in al) a.mediaList])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => [for (final m in ml) m.subtitleList.firstOrNull].whereType<EnSubtitle>())
          .select((subl) => [for (final sub in subl) sub.sentenceList])
          .select((senll) => senll.expand((e) => e))
          .select((senl) => {for (final sen in senl) sen.id: sen})
          .select((senm) => senm[id]),
    );
    if (sentence == null) return const SentenceCardState.empty();
    final int? playingSentenceId = ref.watch(
      playerProvider.select((st) => st?.playingSentenceId),
    );

    String formatDuration(Duration d) {
      final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      final milliseconds = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
      return '$minutes:$seconds.$milliseconds';
    }

    return SentenceCardState(
      text: sentence.text,
      period: '${formatDuration(sentence.start)} - ${formatDuration(sentence.end)}',
      isPlaying: sentence.id == playingSentenceId,
    );
  }
}
