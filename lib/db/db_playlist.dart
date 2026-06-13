import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBPlaylist {
  final Store _store;
  DBPlaylist(this._store);



  Future<Playlist?> create(Playlist playlist, File? coverFile) async {
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
    playlist = await _store.box<Playlist>().putAndGetAsync(playlist);
    return playlist;
  }

  Future<List<Playlist>> getAll() async {
    final query = _store.box<Playlist>()
        .query()
        .order(Playlist_.sortOrder, flags: Order.descending)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  Future<Playlist?> get(int id) async {
    return await _store.box<Playlist>().getAsync(id);
  }

  Future<(Playlist, Playlist)> swapSortOrder(Playlist aPlaylist, Playlist bPlaylist) async {
    final aSortOrder = aPlaylist.sortOrder;
    aPlaylist = aPlaylist.copyWith(sortOrder: bPlaylist.sortOrder);
    bPlaylist = bPlaylist.copyWith(sortOrder: aSortOrder);
    await updateMany([aPlaylist, bPlaylist]);
    return (aPlaylist, bPlaylist);
  }

  Future<void> update(Playlist playlist) async {
    await updateMany([playlist]);
  }

  Future<void> updateMany(List<Playlist> playlists) async {
    await _store.box<Playlist>().putManyAsync(playlists);
    //TODO if cover empty, remove covers
  }

  Future<void> remove(Playlist playlist) async {
    await removeMany([playlist]);
  }

  Future<void> removeMany(Iterable<Playlist> playlists) async {
    if (playlists.isEmpty) return;
    if (playlists.any((p) => p.id == 0)) return;

    final ids = playlists.map((p) => p.id).toList();
    await _store.box<Playlist>().removeManyAsync(ids);
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
