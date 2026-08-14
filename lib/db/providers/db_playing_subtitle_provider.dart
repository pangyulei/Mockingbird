import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/db/providers/db_metadata_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_playing_subtitle_list_provider.dart';
import 'db_subtitle_provider.dart';

part 'db_playing_subtitle_provider.g.dart';

@Riverpod(name: 'dbPlayingSubtitleProvider')
class DBPlayingSubtitle extends _$DBPlayingSubtitle {
  @override
  Future<SubtitleEntity?> build() async {
    final subtitleName = await ref.watch(
      dbMetadataProvider.selectAsync((st) => st.playingSubtitleName),
    );
    final subtitleList = await ref.watch(dbPlayingSubtitleListProvider.future);
    final matchedSubtitle = subtitleList.firstWhereOrNull((sub) => sub.name == subtitleName);
    final firstSubtitle = subtitleList.firstOrNull;
    return matchedSubtitle ?? firstSubtitle;
  }
}
