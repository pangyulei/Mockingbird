import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/db/providers/db_metadata_provider.dart';
import 'package:mockingbird/db/providers/db_subtitle_list_provider.dart';
import 'package:mockingbird/db/providers/db_subtitle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_subtitle_provider.g.dart';

@Riverpod(name: 'dbPlayingSubtitleProvider')
class DBPlayingSubtitle extends _$DBPlayingSubtitle {
  @override
  Future<SubtitleEntity?> build() async {
    final subtitleName = await ref.watch(
      dbMetadataProvider.selectAsync((st) => st.playingSubtitleName),
    );
    var subtitle = await ref.watch(dbSubtitleProvider(subtitleName).future);
    if (subtitle == null) {
      //可能用户把字幕文件名改了
      final subtitleList = await ref.watch(dbSubtitleListProvider.future);
      subtitle = subtitleList.firstOrNull;
    }
    return subtitle;
  }
}
