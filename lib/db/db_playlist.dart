import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBPlaylist {
  final Box<Playlist> _box;
  DBPlaylist(Store store) : _box = store.box<Playlist>();

  Future<Playlist?> createAsync(Playlist playlist, File? cover) async {
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
    final newPlaylist = playlist
        .copyWith(name: trimmedName, cover: coverPath); 
    await _box.putAsync(newPlaylist); //will fill id field
    return newPlaylist;
  }

  Future<List<Playlist>> getAllAsync() async {
    final query = _box
        .query()
        .order(Playlist_.sortOrder, flags: Order.descending)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  Future<List<Playlist>> updateSortOrdersAsync(List<Playlist> playlists) async {
    // Update sortOrder for each playlist based on its position in the list
    // Position [0] gets the highest sortOrder (newest first)
    final updatedPlaylists = playlists
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: playlists.length - 1 - e.key))
        .toList();
    await _box.putManyAsync(updatedPlaylists);
    return updatedPlaylists;
  }

  Future<void> removeAsync(Playlist playlist) async {
    await removeManyAsync([playlist]);
  }

  Future<void> removeManyAsync(List<Playlist> playlists) async {
    if (playlists.isEmpty) return;
    if (playlists.any((p) => p.id == 0)) return;

    final ids = playlists.map((p) => p.id).toList();
    await _box.removeManyAsync(ids);
    // Delete cover files for removed playlists
    final uselessCovers = playlists
        .where((p) => p.cover != null)
        .map((p) => File(p.cover!));
    final removeCovers = uselessCovers.map((cover) async {
      if (await cover.exists()) {
        await cover.delete();
      }
    });
    await Future.wait(removeCovers);
  }
}
