import 'dart:io';

import 'package:mockingbird/db/entities/db_album.dart';
import 'package:mockingbird/db/entities/db_media.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album/album_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_provider.g.dart';

@Riverpod(name: 'albumAsyncProvider')
class AlbumAsync extends _$AlbumAsync {
  DBAlbum? _album;
  @override
  Future<DBAlbum?> build(int id) async {
    _album = ref.watch(dbAlbumAsyncProvider(id)).value;
    _album?.medias.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return _album;
  }
}

@Riverpod(name: 'albumProvider')
class Album extends _$Album {
  @override
  AlbumState? build(int id) {
    final album = ref.watch(albumAsyncProvider(id)).value;
    if (album == null) {
      return null;
    } else {
      final coverPath = album.cover;
      return AlbumState(
        name: album.name,
        cover: coverPath == null ? null : File(coverPath),
        mediaStates: album.medias.map((m) => m.toCardState()).toList(),
      );
    }
  }
}

extension on DBMedia {
  MediaCardState toCardState() {
    return MediaCardState(
      name: name,
      type: type,
      hasSubtitle: subtitles.isNotEmpty,
      isPlaying: false,
    );
  }
}
