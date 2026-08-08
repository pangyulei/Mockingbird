import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'db_playing_sentence_provider.g.dart';

@riverpod
class DBPlayingSentence extends _$DBPlayingSentence {
  @override
  Future<SentenceEntity?> build(String id) async {
    final sentence = await ref.watch(
      dbPlayingSubtitleListProvider.selectAsync((subl) {
        final senll = subl.map((sub) => sub.sentenceList).toList();
        final senl = senll.expand((e) => e).toList();
        final senmap = {for (final sen in senl) sen.id: sen};
        return senmap[id];
      }),
    );
    return sentence;
  }
}
