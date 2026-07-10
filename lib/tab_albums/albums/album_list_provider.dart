import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/album_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_list_provider.g.dart';

@Riverpod(name: 'albumListProvider')
class AlbumList extends _$AlbumList {
  List<EnAlbum> _albums = [];

  @override
  Future<AlbumListState> build() async {
    final albums = await ref.watch(dbAlbumsProvider.future);
    _albums = albums;
    return AlbumListState(states: _albums.map((a) => a.toCardState()).toList());
  }

  int? idForIndex(int i) {
    return _albums.elementAtOrNull(i)?.id;
  }

  String? nameForIndex(int i) {
    return _albums.elementAtOrNull(i)?.name;
  }

  Future<void> deleteAlbum(int i) async {
    final album = _albums.elementAtOrNull(i);
    if (album == null) {
      return;
    }
    state = const AsyncLoading();
    await ref.read(dbAlbumsProvider.notifier).deleteAlbum(album);
  }
}

extension on EnAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
