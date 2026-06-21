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
        '${DateTime.now().millisecondsSinceEpoch}';
    return p.join(coversDir.path, fileName);
  }

  Future<Album?> create({
    required String name,
    File? cover
  }) async {

    //校验 name
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    //保存封面
    final String? coverPath;
    if (cover != null) {
      coverPath = await _coverPath;
      await cover.copy(coverPath);
    } else {
      coverPath = null;
    }
    //获取 最大SortOrder
    final albumBox = _store.box<Album>();
    final query = albumBox
        .query()
        .order(Album_.sortOrder, flags: Order.descending)
        .build();
    final maxSortOrderAlbum = await query.findFirstAsync();
    query.close();

    final sortOrder = maxSortOrderAlbum != null ? maxSortOrderAlbum.sortOrder + 1 : 0;
    return await _store.box<Album>().putAndGetAsync(Album(name: trimmedName, sortOrder: sortOrder, cover: coverPath));
  }

  Future<Album> update({
    required Album album,
    required String name,
    File? cover,
  }) async {
    Album updateAlbum = album.copyWith();
    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      updateAlbum = updateAlbum.copyWith(name: trimmedName);
    }

    if (cover == null || cover.path != album.cover) {
      if (album.cover != null) {
        final oldCover = File(album.cover!);
        if (await oldCover.exists()) {
          await oldCover.delete();
        }
        updateAlbum = updateAlbum.copyWith(cover: () => null);
      }
    }

    if (cover != null && cover.path != album.cover) {
      final coverPath = await _coverPath;
      await cover.copy(coverPath);
      updateAlbum = updateAlbum.copyWith(cover: () => coverPath);
    }
    if (updateAlbum.cover != album.cover || updateAlbum.name != album.name) {
      return _store.box<Album>().putAndGetAsync(updateAlbum);
    } else {
      return album;
    }
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

  Future<void> removeMany(Iterable<Album> albums) async {
    if (albums.isEmpty) return;
    assert(albums.every((a) => a.id != 0), 'try to remove albums without id');

    final ids = albums.map((p) => p.id).toList();
    await _store.box<Album>().removeManyAsync(ids);
    // Delete cover files for removed playlists
    final uselessCovers = albums
        .where((a) => a.cover != null)
        .map((a) => File(a.cover!));
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
