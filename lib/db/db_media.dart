import 'dart:io';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:mockingbird/model/subtitle.dart';
import 'package:mockingbird/model/sentence.dart';
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
    final constructSubtitles = readFiles.where((rf) => rf.subtitle != null).map((rf) => rf.subtitle!).map((s) => SubtitleParser.parseFile(s));
    final subtitlesWithoutId = await Future.wait(constructSubtitles);
    //construct media models, prepared for save them to db
    final constructMedias = dirMediaFiles.asMap().entries.map((e) async {
      int i = e.key;
      final dirMedia = e.value;
      final mediaName = p.basenameWithoutExtension(readFiles[i].media.path);
      final media = Media(path: dirMedia.path, name: mediaName);
      media.albums.add(album);
      media.subtitles.addAll(subtitlesWithoutId);
      return media;
    }).toList();
    final mediasWithoutId = await Future.wait(constructMedias);
    final medias = await _store.box<Media>().putAndGetManyAsync(mediasWithoutId);
    return medias;
  }

  Future<void> update(Media media) async {
    await _store.box<Media>().putAsync(media);
  }

  Future<void> remove(Media media) async {
    await _store.runInTransactionAsync(TxMode.write, (Store store, int mediaId) {
      final mediaBox = store.box<Media>();
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();

      final m = mediaBox.get(mediaId);
      if (m == null) return;
      final sentences = m.subtitles.map((st) => st.sentences).expand((e) => e).toList();
      mediaBox.remove(mediaId);
      subtitleBox.removeMany(m.subtitles.map((s) => s.id).toList());
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());

    }, media.id);

    // Remove file
    final file = File(media.path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> removeSubtitle(Media media) async {
    if (media.subtitles.isEmpty) return;

    await _store.runInTransactionAsync(TxMode.write, (Store store, int mediaId) {
      final mediaBox = store.box<Media>();
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();

      final m = mediaBox.get(mediaId);
      if (m == null) return;
      final sentences = m.subtitles.map((st) => st.sentences).expand((e) => e).toList();
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());
      subtitleBox.removeMany(m.subtitles.map((s) => s.id).toList());
      m.subtitles.clear();
      mediaBox.put(m);
    }, media.id);
  }
}
