import 'dart:io';
import 'package:mockingbird/models/playlist.dart';
import 'db.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBPlaylist {
  static Box<Playlist> _box() => DB.instance.store.box<Playlist>();

  static Future<Playlist?> create(Playlist newPlaylist, File? cover) async {
    final trimmedName = newPlaylist.name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }
    newPlaylist.name = trimmedName;
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

  static Future<List<Playlist>> all() async => await _box().getAllAsync();
}
