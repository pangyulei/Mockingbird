import 'dart:io';

import 'package:mockingbird/models/track.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/playlist.dart';

class DBTrack {
  final Store _store;
  DBTrack(this._store);

  Future<List<Track>> createMany(
      Playlist playlist,
      List<({File trackFile, File? subFile})> relatedFiles) async {
    if (relatedFiles.isEmpty) return [];

    final appDir = await getApplicationDocumentsDirectory();
    final tracksDir = Directory(p.join(appDir.path, 'tracks'));
    final subsDir = Directory(p.join(appDir.path, 'subtitles'));

    // Ensure directories exist in parallel
    await Future.wait([
      if (!await tracksDir.exists()) tracksDir.create(recursive: true),
      if (!await subsDir.exists()) subsDir.create(recursive: true),
    ]);

    // Optimize: Use a single timestamp and index to ensure unique filenames

    final saveTasks = relatedFiles.asMap().entries.map((entry) async {
      final i = entry.key;
      final rf = entry.value;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueName = "${timestamp}_$i";

      final results = await Future.wait([
        rf.trackFile.copy(
          p.join(tracksDir.path, "$uniqueName${p.extension(rf.trackFile.path)}"),
        ),
        if (rf.subFile != null)
          rf.subFile!.copy(
            p.join(subsDir.path, "$uniqueName${p.extension(rf.subFile!.path)}"),
          ),
      ]);

      return (
        track: results[0],
        sub: rf.subFile != null ? results[1] : null,
        original: rf.trackFile
      );
    });

    final savedResults = await Future.wait(saveTasks);

    var tracks = savedResults.map((res) {
      final type = TrackType.fromFile(res.track);
      return Track(
        pathStr: res.track.path,
        subPathStr: res.sub?.path,
        name: p.basenameWithoutExtension(res.original.path),
        rawType: type.raw,
        playlist: playlist,
      );
    }).toList();
    tracks = await _store.box<Track>().putAndGetManyAsync(tracks);
    playlist.tracks.addAll(tracks);
    return tracks;
  }

}
