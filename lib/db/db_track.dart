
import 'dart:io';

import 'package:mockingbird/models/track.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DBTrack {
  final Store _store;
  DBTrack(this._store);

  Future<List<Track>> createMany(List<File> files) async {
    if (files.isEmpty) return [];
    //make sure appDir/tracks exist
    final appDir = await getApplicationDocumentsDirectory();
    final tracksDir = Directory(p.join(appDir.path, 'tracks'));
    if (!await tracksDir.exists()) {
      await tracksDir.create(recursive: true);
    }
    //write all trackfiles into that dir, rename to timestamp unique filename
    final saveTrackFiles = files.map((file) async {
      String filename = "${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}";
      final savedFile = await file.copy(p.join(tracksDir.path, filename));
      return savedFile.path;
    });
    final trackPathsInAppDir = await Future.wait(saveTrackFiles);
    final tracks = List.generate(files.length, (i) {
      //TODO allowed extensions should be at a public accessible const
      const audioExtensions = [
        'mp3',
        'wav',
        'aac',
        'm4a',
        'flac',
        'ogg',
        'wma',
      ];
      final extension = p.extension(trackPathsInAppDir[i]).substring(1);
      final type = audioExtensions.contains(extension)
          ? TrackType.audio
          : TrackType.video;
      return Track(
          pathStr: trackPathsInAppDir[i],
          name: p.basenameWithoutExtension(files[i].path),
          rawType: type.raw
      );
    });
    await _store.box<Track>().putManyAsync(tracks);
    return tracks; //now tracks contains updated id
  }

  Future<List<Track>> getByPlaylistIdAsync(int playlistId) async {
    // Note: Track doesn't have playlistId field in current model
    // This would need to be implemented based on actual relationship design
    final query = _store.box<Track>()
        .query()
        .order(Track_.name)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }
}
