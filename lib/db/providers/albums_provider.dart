import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/album.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlbumsNotifier extends AsyncNotifier<List<Album>> {
  final _lock = Lock();

  @override
  Future<List<Album>> build() async {
    return await DBLogic().loadAlbums();
  }

  Future<void> createAlbum(String name, File? cover) async {
    return _lock.synchronized(() async {
      final cachedAlbums = state.value ?? [];
      state = await AsyncValue.guard(() async {
        final newAlbum = await DBLogic().createAlbum(name, cover: cover);
        if (newAlbum == null) {
          return cachedAlbums;
        } else {
          return [...cachedAlbums, newAlbum];
        }
      });
    });
  }

  Future<void> deleteAlbum(Album album) async {
    return _lock.synchronized(() async {
      final cachedAlbums = state.value ?? [];
      state = await AsyncValue.guard(() async {
        await DBLogic().deleteAlbum(album);
        return cachedAlbums.where((a) => a.id != album.id).toList();
      });
    });
  }
}

final albumsProvider = AsyncNotifierProvider.autoDispose(AlbumsNotifier.new);
