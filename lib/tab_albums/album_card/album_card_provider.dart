import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard {
  EnAlbum? _album;

  @override
  AlbumCardState build(int? id) {
    if (id == null) return const AlbumCardState.empty();
    final album = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    _album = album;
    if (album == null) return const AlbumCardState.empty();
    return album.toCardState();
  }

  Future<void> delete() async {
    final album = _album;
    if (album == null) return;
    EasyLoading.show(maskType: .clear);
    await ref.read(dbAlbumListProvider.notifier).deleteAlbum(album);
    EasyLoading.dismiss();
  }

  String? get albumName => _album?.name;
}

extension on EnAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
