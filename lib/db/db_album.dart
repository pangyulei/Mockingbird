import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBAlbum {
  final Store _store;
  DBAlbum(this._store);

  Future<Album?> create(Album playlist, File? coverFile) async {
    final trimmedName = playlist.name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }
    final String? coverPathStr;
    if (coverFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final coversDir = Directory(p.join(appDir.path, 'playlist_covers'));

      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }
      // Generate a unique filename using timestamp and original extension
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}${p.extension(coverFile.path)}';
      final savedFile = await coverFile.copy(p.join(coversDir.path, fileName));
      coverPathStr = savedFile.path;
    } else {
      coverPathStr = null;
    }
    playlist = playlist.copyWith(name: trimmedName, coverPathStr: coverPathStr);
    playlist = await _store.box<Album>().putAndGetAsync(playlist);
    return playlist;
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

  Future<(Album, Album)> swapSortOrder(Album aPlaylist, Album bPlaylist) async {
    final aSortOrder = aPlaylist.sortOrder;
    aPlaylist = aPlaylist.copyWith(sortOrder: bPlaylist.sortOrder);
    bPlaylist = bPlaylist.copyWith(sortOrder: aSortOrder);
    await updateMany([aPlaylist, bPlaylist]);
    return (aPlaylist, bPlaylist);
  }

  Future<void> update(Album playlist) async {
    await updateMany([playlist]);
  }

  Future<void> updateMany(List<Album> playlists) async {
    await _store.box<Album>().putManyAsync(playlists);
    //TODO if cover empty, remove covers
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
        .where((p) => p.coverPathStr != null)
        .map((p) => File(p.coverPathStr!));
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
