import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/tab_albums/album/album_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_provider.g.dart';

@Riverpod(name: 'albumProvider')
class Album extends _$Album {
  @override
  Future<AlbumState?> build(int id) async {
    final album = ref.watch(dbAlbumProvider(id)).value;
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

  Future<void> onImport(List<File> files) async {
    state = const AsyncLoading();
    await ref.read(dbAlbumProvider(id).notifier).importMediasSubtitles(files);
    ref.invalidateSelf();
  }
}

extension on EnMedia {
  MediaCardState toCardState() {
    return MediaCardState(
      name: name,
      type: type,
      hasSubtitle: subtitles.isNotEmpty,
      isPlaying: false,
    );
  }
}
