import 'dart:async';

import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/albums_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'albums_provider.g.dart';

@Riverpod(name: 'albumsAsyncProvider')
class AlbumsAsync extends _$AlbumsAsync {
  List<Album> _albums = [];
  @override
  FutureOr<List<Album>> build() async {
    final albums = ref.watch(dbAlbumsAsyncProvider).value;
    _albums = albums ?? [];
    return _albums;
  }
}

@Riverpod(name: 'albumsProvider')
class Albums extends _$Albums {
  @override
  AlbumsState build() {
    final albums = ref.watch(albumsAsyncProvider).value ?? [];
    return AlbumsState(
      isLoading: false,
      states: albums.map((a) => a.toCardState()).toList(),
    );
  }
}

extension on Album {
  AlbumCardState toCardState() {
    return AlbumCardState(mediasCount: medias.length, name: name, cover: cover);
  }
}
