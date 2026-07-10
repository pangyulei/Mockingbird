import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/db_album.dart';
import 'package:mockingbird/db/providers/db_albums_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'db_album_provider.g.dart';

@Riverpod(name: 'dbAlbumAsyncProvider')
class DBAlbumAsync extends _$DBAlbumAsync {
  final _lock = Lock();

  @override
  Future<DBAlbum?> build(int id) async {
    ref.onDispose(() {
      debugPrint(
        'DBAlbumAsyncNotifier($id) ${identityHashCode(this)} disposed',
      );
    });
    return await DBLogic().loadAlbum(id);
  }

  Future<DBAlbum?> updateAlbum({String? name, File? Function()? cover}) async {
    return await _lock.synchronized(() async {
      final album = state.value;
      if (album == null) {
        return null;
      }
      state = await AsyncValue.guard(() async {
        return await DBLogic().updateAlbum(album, name: name, cover: cover);
      });
      final updatedAlbum = state.value;
      if (updatedAlbum != null) {
        ref.read(dbAlbumsAsyncProvider.notifier).updateAlbum(updatedAlbum);
      }
      return updatedAlbum;
    });
  }
}
