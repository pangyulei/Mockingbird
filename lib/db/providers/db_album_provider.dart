import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_provider.g.dart';

@Riverpod(name: 'dbAlbumProvider')
class DBAlbum extends _$DBAlbum {
  @override
  Future<EnAlbum?> build(int id) async {
    ref.onDispose(() {
      debugPrint('DBAlbumNotifier($id) ${identityHashCode(this)} disposed');
    });
    final album = await DBLogic().loadAlbum(id);
    album?.sortMedias();
    return album;
  }

  Future<void> updateAlbum({String? name, File? Function()? cover}) async {
    final album = state.value;
    if (album == null) {
      return;
    }
    debugPrint(
      'album($id) ${identityHashCode(state)} before: \n${album.name}\n${album.cover}',
    );
    state = await AsyncValue.guard(() async {
      final updatedAlbum = await DBLogic().updateAlbum(
        album,
        name: name,
        cover: cover,
      );
      ref.read(dbAlbumsProvider.notifier).updateByAlbumUpdated(updatedAlbum);
      return updatedAlbum;
    });
    debugPrint(
      'album($id) ${identityHashCode(state)} after: \n${state.value?.name}\n${state.value?.cover}',
    );
  }

  Future<void> importMediasSubtitles(List<File> files) async {
    final album = await future;
    if (album == null) {
      debugPrint('album==null, can NOT import medias');
      return;
    }
    state = await AsyncValue.guard(() async {
      final medias = await DBLogic().importMediaAndSubtitles(album, files);
      if (medias.isNotEmpty) {
        album.medias.addAll(medias);
        album.sortMedias();
      }
      //notify dbAlbums update
      await ref.read(dbAlbumsProvider.notifier).updateByAlbumUpdated(album);
      return album;
    });
  }

  Future<void> updateByMediaUpdated(EnMedia updatedMedia) async {
    final album = await future;
    if (album == null) {
      return;
    }
    final updatedMedias = album.medias
        .map((media) => media.id == updatedMedia.id ? updatedMedia : media)
        .toList();
    final updatedAlbum = album.copyWith(medias: updatedMedias);
    updatedAlbum.sortMedias();
    state = AsyncData(updatedAlbum);
    await ref
        .read(dbAlbumsProvider.notifier)
        .updateByAlbumUpdated(updatedAlbum);
  }

  Future<void> updateByMediaDeleted(int mediaId) async {
    final album = await future;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    album.medias.removeWhere((media) => media.id == mediaId);
    state = AsyncData(album);
    await ref.read(dbAlbumsProvider.notifier).updateByAlbumUpdated(album);
  }

  EnMedia? mediaAtIndex(int i) {
    final album = state.value;
    return album?.medias.elementAtOrNull(i);
  }
}

extension on EnAlbum {
  void sortMedias() {
    medias.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
