import 'dart:io';

import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/en_album.dart';

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
      final albums = state.value ?? [];
      state = AsyncData([newAlbum, ...albums]);
    }
  }

  Future<void> updateAlbum(
    EnAlbum album, {
    String? name,
    File? Function()? cover,
  }) async {
    final updatedAlbum = await DBLogic().updateAlbum(
      album,
      name: name,
      cover: cover,
    );
    if (updatedAlbum != album) {
      _replaceAlbum(updatedAlbum);
    }
  }

  Future<void> deleteAlbum(EnAlbum album) async {
    await DBLogic().deleteAlbum(album);
    final albums = state.value ?? [];
    albums.removeWhere((a) => a.id == album.id);
    state = AsyncData(albums);
  }

  void _replaceAlbum(EnAlbum album) {
    var albums = state.value ?? [];
    albums = albums.map((a) => a.id == album.id ? album : a).toList();
    state = AsyncData(albums);
  }

  Future<void> importResourcesIntoAlbum(EnAlbum album, List<File> files) async {
    await DBLogic().importMediaAndSubtitles(album, files);
    final updatedAlbum = await DBLogic().loadAlbum(album.id);
    if (updatedAlbum != null) {
      _replaceAlbum(updatedAlbum);
    }
  }

  Future<void> deleteMedia(EnMedia media) async {
    await DBLogic().deleteMedia(media);
    final album = media.albums.firstOrNull;
    if (album == null) return;
    album.medias.removeWhere((m) => m.id == media.id);
    _replaceAlbum(album);
  }

  Future<void> addSubtitle(EnMedia media, EnSubtitle subtitle) async {
    final updatedMedia = await DBLogic().addSubtitle(media, subtitle);
    final updatedAlbum = updatedMedia.albums.firstOrNull;
    if (updatedAlbum != null) {
      _replaceAlbum(updatedAlbum);
    }
  }

  Future<void> deleteSubtitle(EnMedia media) async {
    final updatedMedia = await DBLogic().deleteSubtitle(media);
    final updatedAlbum = updatedMedia.albums.firstOrNull;
    if (updatedAlbum != null) {
      _replaceAlbum(updatedAlbum);
    }
  }
}
