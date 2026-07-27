import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_album_provider.g.dart';

@Riverpod(name: 'dbAlbumProvider')
class DBAlbum extends _$DBAlbum {
  @override
  Future<EnAlbum?> build(int? id) async {
    if (id == null) return null;
    debugPrint('album($id) build');
    ref.onDispose(() => debugPrint('album($id) dispose'));
    final album = await DBLogic().loadAlbum(id);
    if (album == null) return null;
    final mediaIdList = album.mediaList.map((m) => m.id).toList();
    final tasks = mediaIdList
        .map((mid) => ref.watch(dbMediaProvider(mid).future))
        .toList();
    final List<EnMedia> mediaList = (await Future.wait(
      tasks,
    )).whereType<EnMedia>().toList();
    mediaList.sort((a, b) => a.name.compareTo(b.name));
    return album.copyWith(mediaList: mediaList);
  }

  Future<void> edit({String? name, File? Function()? cover}) async {
    final album = await future;
    if (album == null) return;
    await DBLogic().updateAlbum(album, name: name, coverFunc: cover);
    ref.invalidateSelf();
  }

  Future<void> delete() async {
    final album = await future;
    if (album == null) return;
    await DBLogic().deleteAlbum(album);
    ref.invalidateSelf();
  }

  Future<void> importResourcesIntoAlbum(List<File> files) async {
    final album = await future;
    if (album == null) return;
    if (files.isEmpty) return;
    await DBLogic().importMediaAndSubtitles(album, files);
    ref.invalidateSelf();
  }

  Future<void> sortToFirst() async {
    final album = await future;
    if (album == null) return;
    await DBLogic().sortAlbumToFirst(album);
    ref.invalidateSelf();
  }

  Future<void> sortToLast() async {
    final album = await future;
    if (album == null) return;
    await DBLogic().sortAlbumToLast(album);
    ref.invalidateSelf();
  }
}
