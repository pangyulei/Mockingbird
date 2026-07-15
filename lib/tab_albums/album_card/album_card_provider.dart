import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard implements AlbumCardNotifierITF {

  @override
  Future<AlbumCardState> build(int? id) async {
    if (id == null) return const AlbumCardState.empty();
    final album = await ref.watch(dbAlbumProvider(id).future);
    return album?.toCardState() ?? const AlbumCardState.empty();
  }

  @override
  String? get albumName {
    final id = this.id;
    if (id == null) return null;
    return ref.read(dbAlbumProvider(id)).value?.name;
  }

  @override
  Future<void> delete() async {
    final id = this.id;
    if (id == null) return;
    state = const AsyncLoading();
    await ref.read(dbAlbumProvider(id).notifier).delete();
  }
}

extension on EnAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
