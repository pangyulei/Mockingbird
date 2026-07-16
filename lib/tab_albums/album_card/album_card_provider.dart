import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard implements AlbumCardNotifierITF {
  @override
  AlbumCardState build(int? id) {
    if (id == null) return const AlbumCardState.empty();
    final album = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
    debugPrint('album card provider build:\n$album\n');
    ref.onDispose(() {
      debugPrint('album card provider dispose:\n$album\n');
    });
    if (album == null) return const AlbumCardState.empty();
    return album.toCardState();
  }

  @override
  EnAlbum? get album {
    final id = this.id;
    if (id == null) return null;
    return ref.read(
      dbAlbumListProvider
          .select((st) => st.value ?? [])
          .select((al) => {for (final a in al) a.id: a})
          .select((am) => am[id]),
    );
  }

  @override
  Future<void> delete() async {
    final album = this.album;
    if (album == null) return;
    EasyLoading.show(maskType: .clear);
    await ref.read(dbAlbumListProvider.notifier).deleteAlbum(album);
    EasyLoading.dismiss();
  }
}

extension on EnAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
