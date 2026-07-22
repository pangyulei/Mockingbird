import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_media_provider.g.dart';

@Riverpod(name: 'dbPlayingMediaProvider')
class DBPlayingMedia extends _$DBPlayingMedia {
  @override
  Future<EnMedia?> build() async {
    final int? playingId = await ref.watch(
      dbPrefProvider.selectAsync((st) => st.playingId),
    );
    if (playingId == null) return null;
    final EnMedia? media = await ref.watch(
      dbAlbumListProvider.selectAsync((al) {
        final mediaList = al.map((a) => a.mediaList).flattened;
        final mediaMap = {for (final m in mediaList) m.id: m};
        return mediaMap[playingId];
      }),
    );
    return media;
  }
}
