import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_list_provider.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_sentence_provider.g.dart';

@Riverpod(name: 'dbSentenceProvider')
class DBSentence extends _$DBSentence {
  @override
  Future<SentenceEntity?> build(String id) async {
    final subtitle = await ref.watch(dbPlayingSubtitleProvider.future);
    return subtitle?.sentenceList.firstWhereOrNull((sen) => sen.id == id);
  }
}
