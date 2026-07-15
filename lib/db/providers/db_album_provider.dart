import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
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
    final album = await future;
    if (album == null) return;
    final updatedAlbum = await DBLogic().updateAlbum(
      album,
      name: name,
      cover: cover,
    );
    ref.invalidateSelf();
    await ref
        .read(dbAlbumListProvider.notifier)
        .updateByAlbumUpdated(updatedAlbum);
  }

  Future<void> importMediasSubtitles(List<File> files) async {
    final album = await future;
    if (album == null) return;
    await DBLogic().importMediaAndSubtitles(album, files);
    ref.invalidateSelf();
    final updatedAlbum = await future;
    if (updatedAlbum != null) {
      for (final media in updatedAlbum.medias) {
        ref.invalidate(dbMediaProvider(media.id));
      }
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateByAlbumUpdated(updatedAlbum);
    }
  }

  Future<void> updateByMediaUpdated() async {
    ref.invalidateSelf();
    final updatedAlbum = await future;
    if (updatedAlbum != null) {
      await ref
          .read(dbAlbumListProvider.notifier)
          .updateByAlbumUpdated(updatedAlbum);
    }
  }


  Future<void> delete() async {
    final album = await future;
    if (album == null) return;
    await DBLogic().deleteAlbum(album);
    ref.invalidateSelf();
    for (final media in album.medias) {
      ref.invalidate(dbMediaProvider(media.id));
    }
    ref.invalidate(dbPrefProvider);
    await ref.read(dbAlbumListProvider.notifier).updateByAlbumDeleted(album.id);
  }
}

extension on EnAlbum {
  void sortMedias() {
    medias.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
