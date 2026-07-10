import 'package:mockingbird/db/entities/db_album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/albums_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'albums_provider.g.dart';

@Riverpod(name: 'albumsProvider')
class Albums extends _$Albums {
  List<DBAlbum> _albums = [];

  @override
  Future<AlbumsState> build() async {
    final albums = ref.watch(dbAlbumsAsyncProvider).value;
    _albums = albums ?? [];
    return AlbumsState(states: _albums.map((a) => a.toCardState()).toList());
  }

  int? idForIndex(int i) {
    return _albums.elementAtOrNull(i)?.id;
  }
}

extension on DBAlbum {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
