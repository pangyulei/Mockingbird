import 'dart:io';

import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/model/subtitle.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/album.dart';
import '../model/media.dart';

class DBMedia {
  final Store _store;
  DBMedia(this._store);

  Future<List<Media>> importMediasWithSubtitles(
    Album album,
    List<({File media, File? subtitle})> matchedFiles,
  ) async {
    if (matchedFiles.isEmpty) return const [];

    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(appDir.path, 'medias'));
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    // save read media files to app dir
    final saveMediasToDir = matchedFiles.asMap().entries.map((e) {
      final i = e.key;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueName = "${timestamp}_$i";
      final memMedia = e.value.media;
      return memMedia.copy(
        p.join(mediaDir.path, "$uniqueName${p.extension(memMedia.path)}"),
      );
    });
    final dirMediaFiles = await Future.wait(saveMediasToDir);
    final constructSubtitles = matchedFiles.map(
      (mf) => mf.subtitle == null
          ? Future.value(null)
          : SubtitleParser.parseFile(mf.subtitle!),
    );
    final subtitlesWithoutId = await Future.wait(constructSubtitles);
    //construct media models, prepared for save them to db
    final constructMedias = dirMediaFiles.asMap().entries.map((e) async {
      int i = e.key;
      final dirMedia = e.value;
      final mediaName = p.basenameWithoutExtension(matchedFiles[i].media.path);
      final media = Media(
        path: dirMedia.path,
        name: mediaName,
        id: 0,
        versionId: 0,
      );
      final subtitle = subtitlesWithoutId[i];
      media.albums.add(album);
      if ((subtitle != null)) {
        media.subtitles.add(subtitle);
      }
      return media;
    }).toList();
    final mediasWithoutId = await Future.wait(constructMedias);
    final medias = await _store.box<Media>().putAndGetManyAsync(
      mediasWithoutId,
    );
    return medias;
  }

  Future<Media> update(Media media) async {
    return await _store.box<Media>().putAndGetAsync(media);
  }

  Future<Media> addSubtitle(Media media, Subtitle subtitle) async {
    media = await _store.runInTransactionAsync<Media, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<Media>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        throw ArgumentError('mediaId $mediaId not existed');
      }
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();
      final sentences = media.subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());
      subtitleBox.removeMany(media.subtitles.map((s) => s.id).toList());
      media.subtitles.clear();
      media.subtitles.add(subtitle);
      mediaBox.put(media); //will auto update memory media
      return media;
      // final mediaAfter = mediaBox.get(mediaId);
      // if (mediaAfter == null) {
      //   throw ArgumentError('mediaId $mediaId not existed');
      // }
      // return mediaAfter;
      // media.subtitles.clear();
      // mediaBox.put(media);
    }, media.id);
    return media;
  }

  Future<void> remove(Media media) async {
    await _store.runInTransactionAsync<void, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<Media>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        return;
      }
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();
      final sentences = media.subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      mediaBox.remove(mediaId);
      subtitleBox.removeMany(media.subtitles.map((s) => s.id).toList());
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());
    }, media.id);

    // Remove file
    final file = File(media.path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Media> removeSubtitle(Media media) async {
    if (media.subtitles.isEmpty) return media;
    media = await _store.runInTransactionAsync<Media, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<Media>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        throw ArgumentError('mediaId $mediaId not existed');
      }
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();
      final sentences = media.subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());
      subtitleBox.removeMany(media.subtitles.map((s) => s.id).toList());
      media.subtitles.clear();
      return media;
    }, media.id);
    return media;
  }
}
