import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBPlaylist {
  final Store _store;
  DBPlaylist(this._store);

  Future<Playlist?> create(Playlist playlist, File? cover) async {
    final trimmedName = playlist.name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }
    final String? coverPath;
    if (cover != null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final coversDir = Directory(p.join(docsDir.path, 'playlist_covers'));

      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }

      // Generate a unique filename using timestamp and original extension
      final String extension = p.extension(cover.path); //.jpg .png
      final String fileName =
          '${trimmedName}_${DateTime.now().millisecondsSinceEpoch}$extension';
      final File savedFile = await cover.copy(p.join(coversDir.path, fileName));
      coverPath = savedFile.path;
    } else {
      coverPath = null;
    }
    final newPlaylist = playlist.copyWith(name: trimmedName, cover: coverPath);
    await _store.box<Playlist>().putAsync(newPlaylist); //will fill id field
    return newPlaylist;
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

  Future<Playlist?> getById(int id) async {
    return await _store.box<Playlist>().getAsync(id);
  }

  Future<List<Playlist>> swapSortOrder(Playlist aPlaylist, Playlist bPlaylist) async {
    final aSortOrder = aPlaylist.sortOrder;
    final bSortOrder = bPlaylist.sortOrder;
    return (await updateMany([aPlaylist.copyWith(sortOrder: bSortOrder), bPlaylist.copyWith(sortOrder: aSortOrder)]));
  }

  Future<Playlist> update(Playlist playlist) async {
    return (await updateMany([playlist])).first;
  }

  Future<List<Playlist>> updateMany(List<Playlist> playlists) async {
    final updatedPlaylists = playlists.map((p)=>p.copyWith()).toList();
    await _store.box<Playlist>().putManyAsync(updatedPlaylists);
    //TODO if cover empty, remove covers
    return updatedPlaylists;
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
