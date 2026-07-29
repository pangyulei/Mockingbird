import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard {
  @override
  AlbumCardState build(int? id) {
    final album = ref.watch(dbAlbumProvider(id).select((st)=>st.value));
    if (album == null) return const AlbumCardState.empty();
    final albumCount = ref.watch(
      dbAlbumListProvider.select((st) => st.value?.length ?? 0),
    );
    return AlbumCardState(
      mediaCount: album.mediaList.length,
      name: album.name,
      cover: album.cover,
      canSort: albumCount >= 2,
    );
  }

  Future<void> sortToFirst() async {
    await ref.read(dbAlbumProvider(id).notifier).sortToFirst();
  }

  Future<void> sortToLast() async {
    await ref.read(dbAlbumProvider(id).notifier).sortToLast();
  }

  Future<void> delete() async {
    await ref.read(dbAlbumProvider(id).notifier).delete();
  }
}
