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
      debugPrint(
        'DBAlbumNotifier($id) ${identityHashCode(this)} disposed',
      );
    });
    return await DBLogic().loadAlbum(id);
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
}
