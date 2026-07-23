import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard {
  

  @override
  AlbumCardState build(int? id) {
    if (id == null) return const AlbumCardState.empty();
    final album = ref.watch(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    if (album == null) return const AlbumCardState.empty();
    final albumCount = ref.watch(dbAlbumListProvider.select((st) => st.value?.length ?? 0));
    return AlbumCardState(mediasCount: album.mediaList.length, name: album.name, cover: album
        .cover, canSort: albumCount >= 2);
  }

  EnAlbum? get _album => ref.read(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );

  Future<void> sortToFirst() async {
    final album = _album;
    if (album == null) return;
    await ref.read(dbAlbumListProvider.notifier).sortAlbumToFirst(album);
  }

  Future<void> sortToLast() async {
    final album = _album;
    if (album == null) return;
    await ref.read(dbAlbumListProvider.notifier).sortAlbumToLast(album);
  }

  Future<void> delete() async {
    final album = _album;
    if (album == null) return;
    await ref.read(dbAlbumListProvider.notifier).deleteAlbum(album);
  }

  String? get albumName => _album?.name;
}