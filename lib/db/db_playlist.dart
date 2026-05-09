import 'dart:io';

import 'package:mockingbird/models/playlist.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'db.dart';

class DBPlaylist {
  //TODO should i use class-level methods? or better instance-level for better memory,
  //TODO will classlevel codes always in memory
  static Box<Playlist> _box() => DB.instance.store.box<Playlist>();

  static Future<Playlist?> createAsync(String name, File? cover) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    // Set sortOrder to the next available position
    final allPlaylists = await getAllAsync();
    final sortOrder = allPlaylists.length;
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
    final newPlaylist = Playlist(trimmedName, sortOrder, cover: coverPath);
    await _box().putAsync(newPlaylist); //will fill id field
    return newPlaylist;
  }

  //TODO rename to same with objectbox getAllAsync
  static Future<List<Playlist>> getAllAsync() async {
    final playlists = await _box().getAllAsync();
    // Sort by sortOrder descending (newest first)
    playlists.sort((a, b) => b.sortOrder.compareTo(a.sortOrder));
    return playlists;
  }

  static Future<List<Playlist>> updateSortOrdersAsync(
    List<Playlist> playlists,
  ) async {
    // Update sortOrder for each playlist based on its position in the list
    // Position [0] gets the highest sortOrder (newest first)
    final updatedPlaylists = playlists
        .asMap()
        .entries
        .map((e) => e.value.copyWith(sortOrder: playlists.length - 1 - e.key))
        .toList();
    await _box().putManyAsync(updatedPlaylists);
    return updatedPlaylists;
  }

  static Future<void> removeAsync(Playlist playlist) async {
    await removeManyAsync([playlist]);
  }

  static Future<void> removeManyAsync(List<Playlist> playlists) async {
    if (playlists.isEmpty) return;

    final ids = playlists.map((p) => p.id).toList();
    await _box().removeManyAsync(ids);

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
