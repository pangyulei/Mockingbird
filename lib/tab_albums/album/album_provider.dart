import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/tab_albums/album/album_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_provider.g.dart';

@riverpod
class Album extends _$Album {
  @override
  Future<AlbumState?> build(int id) async {
    debugPrint('albumProvider($id) build');
    ref.onDispose(() {
      debugPrint('albumProvider($id) disposed');
    });
    final album = await ref.watch(dbAlbumProvider(id).future);
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

  int? mediaIdAtIndex(int i) {
    final media = ref.read(dbAlbumProvider(id).notifier).mediaAtIndex(i);
    return media?.id;
  }

  Future<void> import(List<File> files) async {
    state = const AsyncLoading();
    await ref.read(dbAlbumProvider(id).notifier).importMediasSubtitles(files);
  }

  Future<void> addCover(File cover) async {
    state = const AsyncLoading();
    await ref
        .read(dbAlbumProvider(id).notifier)
        .updateAlbum(cover: () => cover);
  }

  Future<void> deleteSubtitle(int i) async {
    state = const AsyncLoading();
    final mediaId = await mediaIdAtIndex(i);
    if (mediaId != null) {
      await ref.read(dbMediaProvider(mediaId).notifier).deleteSubtitle();
    }
  }

  Future<void> addSubtitle(int i, EnSubtitle subtitle) async {
    state = const AsyncLoading();
    final mediaId = await mediaIdAtIndex(i);
    if (mediaId != null) {
      await ref.read(dbMediaProvider(mediaId).notifier).addSubtitle(subtitle);
    }
  }

  Future<void> deleteMedia(int i) async {
    state = const AsyncLoading();
    final mediaId = mediaIdAtIndex(i);
    if (mediaId != null) {
      await ref.read(dbMediaProvider(mediaId).notifier).delete();
    }
  }

  Future<void> playMedia(int i) async {
    final media = ref.read(dbAlbumProvider(id).notifier).mediaAtIndex(i);
    if (media == null) {
      debugPrint('media==null at index $i');
      return;
    }
    final updatedMediaStates = state.value?.mediaStates.asMap().entries.map((e) {
      return e.value.copyWith(isPlaying: e.key == i);
    }).toList();
    state = AsyncData(state.value?.copyWith(mediaStates: updatedMediaStates));
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
