import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_list_provider.g.dart';

@Riverpod(name: 'dbAlbumListProvider')
class DBAlbumList extends _$DBAlbumList {
  @override
  Future<List<EnAlbum>> build() async {
    return await DBLogic().loadAlbums();
  }

  Future<EnAlbum?> createAlbum(String name, {File? cover}) async {
    final newAlbum = await DBLogic().createAlbum(name, cover: cover);
    if (newAlbum != null) {
      final albums = await future;
      albums.add(newAlbum);
      state = AsyncData(albums);
    }
    return newAlbum;
  }

  EnAlbum? albumAtIndex(int i) {
    return state.value?.elementAtOrNull(i);
  }

  Future<void> updateByAlbumUpdated(EnAlbum updatedAlbum) async {
    final albums = await future;
    state = AsyncData(
      albums.map((a) => a.id == updatedAlbum.id ? updatedAlbum : a).toList(),
    );
  }

  Future<void> updateByAlbumDeleted(int id) async {
    final albums = await future;
    state = AsyncData(albums.where((a) => a.id != id).toList());
  }
}
