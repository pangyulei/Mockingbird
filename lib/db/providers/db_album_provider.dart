import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

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

  Future<EnAlbum?> updateAlbum({String? name, File? Function()? cover}) async {
    final album = state.value;
    if (album == null) {
      return null;
    }
    state = await AsyncValue.guard(() async {
      return await DBLogic().updateAlbum(album, name: name, cover: cover);
    });
    final updatedAlbum = state.value;
    if (updatedAlbum != null) {
      ref.read(dbAlbumsProvider.notifier).updateAlbum(updatedAlbum);
    }
    return updatedAlbum;
  }

  Future<void> importMediasSubtitles(List<File> files) async {
    final album = state.value;
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
      return album;
    });
  }
}

extension on EnAlbum {
  void sortMedias() {
    medias.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
