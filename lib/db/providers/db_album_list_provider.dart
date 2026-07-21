import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/en_album.dart';
import 'db_pref_provider.dart';

part 'db_album_list_provider.g.dart';

@Riverpod(name: 'dbAlbumListProvider')
class DBAlbumList extends _$DBAlbumList {
  @override
  Future<List<EnAlbum>> build() async {
    return await DBLogic().loadAlbums();
  }

  Future<void> addAlbum(String name, {File? cover}) async {
    final newAlbum = await DBLogic().createAlbum(name, cover: cover);
    if (newAlbum != null) {
      final albumList = await future;
      state = AsyncData([newAlbum, ...albumList]);
    }
  }

  Future<void> updateMedia(EnMedia media, {String? name, EnSubtitle? Function()? subtitle}) async {
    final updatedMedia = await DBLogic().updateMedia(media, name: name, subtitle: subtitle);
    final album = updatedMedia.albumList.firstOrNull;
    if (album == null) return;
    final newMediaList = album.mediaList
        .map((m) => m.id == updatedMedia.id ? updatedMedia : m)
        .toList();
    final newAlbum = album.copyWith(mediaList: newMediaList);
    await _replaceAlbum(newAlbum);
  }

  Future<void> updateAlbum(EnAlbum album, {String? name, File? Function()? cover}) async {
    final updatedAlbum = await DBLogic().updateAlbum(album, name: name, coverFunc: cover);
    if (updatedAlbum != album) {
      await _replaceAlbum(updatedAlbum);
    }
  }

  Future<void> sortAlbumToFirst(EnAlbum album) async {
    await DBLogic().sortAlbumToFirst(album);
    final albumList = await future;
    state = AsyncData([album, ...albumList.where((a) => a.id != album.id).toList()]);
  }

  Future<void> sortAlbumToLast(EnAlbum album) async {
    await DBLogic().sortAlbumToLast(album);
    final albumList = await future;
    state = AsyncData([...albumList.where((a) => a.id != album.id).toList(), album]);
  }

  Future<void> deleteAlbum(EnAlbum album) async {
    await DBLogic().deleteAlbum(album);
    final albumList = await future;
    state = AsyncData(albumList.where((a) => a.id != album.id).toList());
  }

  Future<void> _replaceAlbum(EnAlbum album) async {
    final albumList = await future;
    state = AsyncData(albumList.map((a) => a.id == album.id ? album : a).toList());
  }

  Future<void> importResourcesIntoAlbum(EnAlbum album, List<File> files) async {
    await DBLogic().importMediaAndSubtitles(album, files);
    final updatedAlbum = await DBLogic().loadAlbum(album.id);
    if (updatedAlbum != null) {
      await _replaceAlbum(updatedAlbum);
    }
  }

  Future<void> deleteMedia(EnMedia media) async {
    final album = media.albumList.firstOrNull;
    if (album == null) return;
    final newMediaList = album.mediaList.where((m) => m.id != media.id).toList();
    final newAlbum = album.copyWith(mediaList: newMediaList);
    await _replaceAlbum(newAlbum);
    await DBLogic().deleteMedia(media);

    // clear playing id if playing media has deleted.
    final playingId = ref.read(dbPrefProvider.select((st) => st.value?.playingId));
    if (playingId == media.id) {
      await ref.read(dbPrefProvider.notifier).setPlayingId(null);
    }
  }
}
