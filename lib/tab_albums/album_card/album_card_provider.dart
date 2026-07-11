import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
part 'album_card_provider.g.dart';

@riverpod
class AlbumCard extends _$AlbumCard {
  @override
  Future<AlbumCardState?> build(int id) async {
    final album = await ref.watch(dbAlbumProvider(id).future);
    return album?.toCardState();
  }

  String? get albumName => ref.read(dbAlbumProvider(id)).value?.name;

  Future<void> delete() async {
    state = const AsyncLoading();
    await ref.read(dbAlbumProvider(id).notifier).delete();
  }
}


extension on EnAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
