import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/db_album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'db_albums_provider.g.dart';

@Riverpod(name: 'dbAlbumsAsyncProvider')
class DBAlbumsAsync extends _$DBAlbumsAsync {
  final _lock = Lock();

  @override
  Future<List<DBAlbum>> build() async {
    return await DBLogic().loadAlbums();
  }

  Future<DBAlbum?> createAlbum(String name, {File? cover}) async {
    return await _lock.synchronized(() async {
      final newAlbum = (await AsyncValue.guard(() async {
        return await DBLogic().createAlbum(name, cover: cover);
      })).value;
      if (newAlbum != null) {
        final cachedAlbums = state.value ?? [];
        state = AsyncData([...cachedAlbums, newAlbum]);
      }
      return newAlbum;
    });
  }

  Future<DBAlbum> updateAlbum(
    DBAlbum album, {
    String? name,
    File? Function()? cover,
  }) async {
    return await _lock.synchronized(() async {
      final av = await AsyncValue.guard(() async {
        return await DBLogic().updateAlbum(album, name: name, cover: cover);
      });
      final updatedAlbum = av.value ?? album;
      final newAlbums = (state.value ?? [])
          .map((a) => a.id == updatedAlbum.id ? updatedAlbum : a)
          .toList();
      state = AsyncData(newAlbums);
      return updatedAlbum;
    });
  }

  Future<void> deleteAlbum(DBAlbum album) async {
    return await _lock.synchronized(() async {
      final cachedAlbums = state.value ?? [];
      state = await AsyncValue.guard(() async {
        await DBLogic().deleteAlbum(album);
        return cachedAlbums.where((a) => a.id != album.id).toList();
      });
    });
  }
}
