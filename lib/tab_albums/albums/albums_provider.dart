import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/albums_state.dart';

class AlbumsAsyncNotifier extends AsyncNotifier<List<Album>> {
  List<Album> _albums = [];
  @override
  FutureOr<List<Album>> build() async {
    final albums = ref.watch(dbAlbumsProvider).value;
    _albums = albums ?? [];
    return _albums;
  }
}

class AlbumsNotifier extends Notifier<AlbumsState> {
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

final albumsProvider = NotifierProvider.autoDispose(AlbumsNotifier.new);
final albumsAsyncProvider = AsyncNotifierProvider.autoDispose(
  AlbumsAsyncNotifier.new,
);
