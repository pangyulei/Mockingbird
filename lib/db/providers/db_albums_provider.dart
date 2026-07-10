import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

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

  void updateAlbum(EnAlbum updatedAlbum) {
    final List<EnAlbum> newAlbums = (state.value ?? [])
        .map((a) => a.id == updatedAlbum.id ? updatedAlbum : a)
        .toList();
    state = AsyncData(newAlbums);
  }

  Future<void> deleteAlbum(EnAlbum album) async {
    final cachedAlbums = state.value ?? [];
    state = await AsyncValue.guard(() async {
      await DBLogic().deleteAlbum(album);
      return cachedAlbums.where((a) => a.id != album.id).toList();
    });
  }
}
