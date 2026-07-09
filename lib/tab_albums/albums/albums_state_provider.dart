import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:mockingbird/db/providers/albums_provider.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums/albums_state.dart';

class AlbumsStateNotifier extends AsyncNotifier<AlbumsState> {
  @override
  FutureOr<AlbumsState> build() async {
    final albums = await ref.watch(albumsProvider.future);
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

final albumsStateProvider = AsyncNotifierProvider.autoDispose(AlbumsStateNotifier.new);
