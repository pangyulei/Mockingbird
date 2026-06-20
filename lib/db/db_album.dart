import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBAlbum {
  final Store _store;
  DBAlbum(this._store);

  Future<Directory> get _coversDir async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory(p.join(appDir.path, 'album_covers'));
  }

  Future<String> get _coverPath async {
    final coversDir = await _coversDir;
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    // Generate a unique filename using timestamp and original extension
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}}';
    return p.join(coversDir.path, fileName);
  }

  Future<Album?> create(Album album, File? cover) async {
    final trimmedName = album.name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    final String? coverPath;
    if (cover != null) {
      coverPath = await _coverPath;
      await cover.copy(coverPath);
    } else {
      coverPath = null;
    }
    album = album.copyWith(name: trimmedName, cover: () => coverPath);
    album = await _store.box<Album>().putAndGetAsync(album);
    return album;
  }

  Future<Album> update({
    required Album album,
    String? newName,
    File? newCover,
    bool removeCover = false}) async {

    if (newName != null) {
      final trimmedNewName = newName.trim();
      if (trimmedNewName.isNotEmpty) {
        album = album.copyWith(name: trimmedNewName);
      }
    }

    if (removeCover || newCover != null) {
      //need remove current cover file in album_covers dir
      if (album.cover != null) {
        final oldCover = File(album.cover!);
        if (await oldCover.exists()) {
          await oldCover.delete();
        }
        album = album.copyWith(cover: () => null);
      }
    }
    if (newCover != null) {
      final coverPath = await _coverPath;
      await newCover.copy(coverPath);
      album = album.copyWith(cover: () => coverPath);
    }
    return _store.box<Album>().putAndGetAsync(album);
  }

  Future<List<Album>> getAll() async {
    final query = _store.box<Album>()
        .query()
        .order(Album_.sortOrder, flags: Order.descending)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  Future<Album?> get(int id) async {
    return await _store.box<Album>().getAsync(id);
  }

  Future<(Album, Album)> swapSortOrder(Album aAlbum, Album bAlbum) async {
    final aSortOrder = aAlbum.sortOrder;
    aAlbum = aAlbum.copyWith(sortOrder: bAlbum.sortOrder);
    bAlbum = bAlbum.copyWith(sortOrder: aSortOrder);
    await _store.box<Album>().putManyAsync([aAlbum, bAlbum]);
    return (aAlbum, bAlbum);
  }


  Future<void> remove(Album playlist) async {
    await removeMany([playlist]);
  }

  Future<void> removeMany(Iterable<Album> playlists) async {
    if (playlists.isEmpty) return;
    if (playlists.any((p) => p.id == 0)) return;

    final ids = playlists.map((p) => p.id).toList();
    await _store.box<Album>().removeManyAsync(ids);
    // Delete cover files for removed playlists
    final uselessCovers = playlists
        .where((p) => p.cover != null)
        .map((p) => File(p.cover!));
    //map is lazy call, it would not execute until someone use it.
    //at this situation is Future.wait will trigger, so every delete() parallel started same time
    final removeCovers = uselessCovers.map((cover) async {
      if (await cover.exists()) {
        await cover.delete();
      }
    });
    await Future.wait(removeCovers);
  }
}
