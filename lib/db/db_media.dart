import 'dart:io';

import 'package:mockingbird/model/subtitle.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../model/media.dart';
import '../model/album.dart';

class DBMedia {
  final Store _store;
  DBMedia(this._store);

  Future<List<Media>> createMany(
      Album album,
      List<({File media, File? subtitle})> readFiles) async {
    if (readFiles.isEmpty) return const [];

    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(appDir.path, 'medias'));
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    // Ensure directories exist in parallel
    // await Future.wait([
    //   if (!await mediaDir.exists()) mediaDir.create(recursive: true),
      // if (!await subtitleDir.exists()) subtitleDir.create(recursive: true),
    // ]);

    // save read media files to app dir
    final saveReadMediasToDir = readFiles.asMap().entries.map((e) {
      final i = e.key;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueName = "${timestamp}_$i";
      final memMedia = e.value.media;
      return memMedia.copy(
        p.join(mediaDir.path, "$uniqueName${p.extension(memMedia.path)}"),
      );
    });
    final dirMediaFiles = await Future.wait(saveReadMediasToDir);
    final constructSubtitles = readFiles.map((rf) => rf.subtitle).map((s) => s != null ? SubtitleParser.parseFile(s) : Future(() => null));
    final subtitlesWithoutId = await Future.wait(constructSubtitles);
    //construct media models, prepared for save them to db
    final constructMedias = dirMediaFiles.asMap().entries.map((e) async {
      int i = e.key;
      final dirMedia = e.value;
      final mediaName = p.basenameWithoutExtension(readFiles[i].media.path);
      final media = Media(path: dirMedia.path, name: mediaName);
      media.albums.add(album);
      media.subtitle.target = subtitlesWithoutId[i];
      return media;
    }).toList();
    final mediasWithoutId = await Future.wait(constructMedias);
    final medias = await _store.box<Media>().putAndGetManyAsync(mediasWithoutId);
    //update subtitles ToOne relations
    final subtitles = medias.where((m) => m.subtitle.target != null && m.id != 0).map((m) {
      Subtitle subtitle = m.subtitle.target!;
      subtitle.media.targetId = m.id;
      return subtitle;
    }).toList();
    await _store.box<Subtitle>().putManyAsync(subtitles);
    album.medias.addAll(medias);
    return medias;
  }
}
