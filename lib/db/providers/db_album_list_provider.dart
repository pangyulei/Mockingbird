import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/providers/db_album_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/en_album.dart';

part 'db_album_list_provider.g.dart';

@Riverpod(name: 'dbAlbumListProvider')
class DBAlbumList extends _$DBAlbumList {
  @override
  Future<List<EnAlbum>> build() async {
    final albumIdList = await DBLogic().loadAlbumIdList();
    final tasks = albumIdList
        .map((aid) => ref.watch(dbAlbumProvider(aid).future))
        .toList();
    final List<EnAlbum> albumList = (await Future.wait(
      tasks,
    )).whereType<EnAlbum>().toList();
    return albumList.sorted((a, b) => b.sortOrder.compareTo(a.sortOrder));
  }

  Future<void> addAlbum(String name, {File? cover}) async {
    await DBLogic().createAlbum(name, cover: cover);
    ref.invalidateSelf();
  }
}
