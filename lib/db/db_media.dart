import 'dart:io';

import 'package:mockingbird/model/sentence.dart';
import 'package:mockingbird/model/subtitle.dart';
import 'package:mockingbird/objectbox.g.dart';
import '../model/media.dart';

class DBMedia {
  final Store _store;
  DBMedia(this._store);


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
