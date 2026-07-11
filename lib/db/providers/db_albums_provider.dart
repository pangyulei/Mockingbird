import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_albums_provider.g.dart';

@Riverpod(name: 'dbAlbumsProvider')
class DBAlbums extends _$DBAlbums {
  @override
  Future<List<EnAlbum>> build() async {
    return await DBLogic().loadAlbums();
  }

  Future<EnAlbum?> createAlbum(String name, {File? cover}) async {
    final newAlbum = (await AsyncValue.guard(() async {
      return await DBLogic().createAlbum(name, cover: cover);
    })).value;
    if (newAlbum != null) {
      final cachedAlbums = state.value ?? [];
      state = AsyncData([...cachedAlbums, newAlbum]);
    }
    return newAlbum;
  }

  Future<void> updateByAlbumUpdated(EnAlbum updatedAlbum) async {
    final albums = await future;
    final updatedAlbums = albums
        .map((a) => a.id == updatedAlbum.id ? updatedAlbum : a)
        .toList();
    state = AsyncData(updatedAlbums);
  }

  void updateByAlbumDeleted(int id) {
    final albums = state.value;
    if (albums != null) {
      state = AsyncData(albums.where((a) => a.id != id).toList());
    }
  }

  EnAlbum? albumAtIndex(int i) {
    return state.value?.elementAtOrNull(i);
  }
}
