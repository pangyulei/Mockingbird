import 'dart:io';
import 'package:mockingbird/models/playlist.dart';
import 'db.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBPlaylist { //TODO should i use class-level methods? or better instance-level for better memory, 
//TODO will classlevel codes always in memory
  static Box<Playlist> _box() => DB.instance.store.box<Playlist>();

  static Future<Playlist?> create(Playlist newPlaylist, File? cover) async {
    final trimmedName = newPlaylist.name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }
    newPlaylist.name = trimmedName;
    
    // Set sortOrder to the next available position
    final allPlaylists = await all();
    newPlaylist.sortOrder = allPlaylists.length;
    
    if (cover != null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final coversDir = Directory(p.join(docsDir.path, 'playlist_covers'));

      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }

      // Generate a unique filename using timestamp and original extension
      final String extension = p.extension(cover.path); //.jpg .png
      final String fileName = '${newPlaylist.name}_${DateTime.now().millisecondsSinceEpoch}$extension';
      final File savedFile = await cover.copy(p.join(coversDir.path, fileName));

      newPlaylist.cover = savedFile.path;
    }
    _box().put(newPlaylist);
    return newPlaylist.copyWith();
  }

  //TODO rename to same with objectbox getAllAsync
  static Future<List<Playlist>> all() async {
    final playlists = await _box().getAllAsync();
    // Sort by sortOrder ascending  //TODO make newest first
    playlists.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return playlists;
  }
  
  static Future<void> updateSortOrders(List<Playlist> playlists) async {
    // Update sortOrder for each playlist based on its position in the list
    for (int i = 0; i < playlists.length; i++) {
      playlists[i].sortOrder = i;//TODO make newest first
      _box().put(playlists[i]);
    }
  }
}
