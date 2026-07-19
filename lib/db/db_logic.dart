import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/entities/en_pref.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef MF_SF = ({File mediaFile, File? subtitleFile});
typedef M_SF = ({EnMedia media, File subtitleFile});

class DBLogic {
  final Store _store;

  DBLogic.test(this._store); //for unit test
  DBLogic() : this.test(DBObjectBox().store);

  Future<EnPref?> loadPref() async {
    final prefs = await _store.box<EnPref>().getAllAsync();
    return prefs.firstOrNull;
  }

  Future<EnPref> updatePref(EnPref pref) async {
    return await _store.box<EnPref>().putAndGetAsync(pref);
  }

  ({List<MF_SF> mfsfList, List<M_SF> msfList}) _processMediaSubtitleFiles(
    List<EnMedia> albumMedias,
    List<File> files,
  ) {
    final List<File> videoFiles = [];
    final List<File> audioFiles = [];
    final List<File> subtitleFiles = [];
    for (var f in files) {
      final ext = p.extension(f.path).replaceFirst('.', '').toLowerCase();
      if (kVideoExtensions.contains(ext)) videoFiles.add(f);
      if (kAudioExtensions.contains(ext)) audioFiles.add(f);
      if (kSubtitleExtensions.contains(ext)) subtitleFiles.add(f);
    }
    final mfsfList = [...videoFiles, ...audioFiles].map((mf) {
      final mediaName = p.basenameWithoutExtension(mf.path);
      final subtitleFile = subtitleFiles.firstWhereOrNull((sf) {
        final subtitleName = p.basenameWithoutExtension(sf.path);
        return subtitleName.contains(mediaName);
      });
      return (mediaFile: mf, subtitleFile: subtitleFile);
    }).toList();

    //deal with unmatched subtitles
    final matchedSubtitlePaths = mfsfList
        .map((mfsf) => mfsf.subtitleFile)
        .whereType<File>()
        .map((sf) => sf.path)
        .toSet();
    final unmatchedSubtitleFiles = subtitleFiles.where(
      (sf) => !matchedSubtitlePaths.contains(sf.path),
    );
    final mediasWithoutSubtitle = albumMedias.where((m) => m.subtitles.isEmpty);
    final msfList = mediasWithoutSubtitle
        .map((m) {
          final subtitleFile = unmatchedSubtitleFiles.firstWhereOrNull((sf) {
            final subtitleName = p.basenameWithoutExtension(sf.path);
            return subtitleName.contains(m.name);
          });
          return (media: m, subtitleFile: subtitleFile);
        })
        .whereType<M_SF>()
        .toList();
    return (mfsfList: mfsfList, msfList: msfList);
  }

  Future<List<EnMedia>> _mediasMadeFromMFSFList(
    EnAlbum album,
    List<MF_SF> mfsfList,
  ) async {
    if (mfsfList.isEmpty) return [];

    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(appDir.path, 'medias'));
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    // save read media files to app dir
    final saveMediasToDir = mfsfList.asMap().entries.map((e) {
      final i = e.key;
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final uniqueName = "${timestamp}_$i";
      final mediaFile = e.value.mediaFile;
      return mediaFile.copy(
        p.join(mediaDir.path, "$uniqueName${p.extension(mediaFile.path)}"),
      );
    });
    final dirMediaFiles = await Future.wait(saveMediasToDir);
    final makeSubtitles = mfsfList.map((mfsf) {
      final subtitleFile = mfsf.subtitleFile;
      return subtitleFile == null
          ? Future.value(null)
          : SubtitleParser.parseFile(subtitleFile);
    });
    final subtitlesWithoutId = await Future.wait(makeSubtitles);
    //construct media models, prepared for save them to db
    final mediasWithoutId = dirMediaFiles.asMap().entries.map((e) {
      int i = e.key;
      final dirMediaFile = e.value;
      final mediaName = p.basenameWithoutExtension(mfsfList[i].mediaFile.path);
      final media = EnMedia(path: dirMediaFile.path, name: mediaName, id: 0);
      media.albums.add(album);
      final subtitle = subtitlesWithoutId[i];
      if ((subtitle != null)) {
        media.subtitles.add(subtitle);
      }
      return media;
    }).toList();
    return mediasWithoutId;
  }

  Future<List<EnMedia>> _mediasFilledSubtitleFromMSFList(
    EnAlbum album,
    List<M_SF> msfList,
  ) async {
    if (msfList.isEmpty) return [];
    final makeSubtitles = msfList
        .map((msf) => msf.subtitleFile)
        .map((sf) => SubtitleParser.parseFile(sf));
    final subtitlesWithoutId = await Future.wait(makeSubtitles);
    final mediasFilledSubtitle = msfList.asMap().entries.map((e) {
      int i = e.key;
      final media = e.value.media;
      final subtitleWithoutId = subtitlesWithoutId[i];
      if (subtitleWithoutId != null) {
        media.subtitles.clear();
        media.subtitles.add(subtitleWithoutId);
      }
      return media;
    }).toList();
    return mediasFilledSubtitle;
  }

  Future<void> importMediaAndSubtitles(EnAlbum album, List<File> files) async {
    final (:mfsfList, :msfList) = _processMediaSubtitleFiles(
      album.medias,
      files,
    );
    final mediasMade = await _mediasMadeFromMFSFList(album, mfsfList);
    final mediasFilled = await _mediasFilledSubtitleFromMSFList(album, msfList);
    await _store.box<EnMedia>().putAndGetManyAsync([
      ...mediasMade,
      ...mediasFilled,
    ]);
  }

  Future<EnMedia> updateMedia(EnMedia media) async {
    return await _store.box<EnMedia>().putAndGetAsync(media);
  }

  Future<EnMedia> updateSubtitle(EnMedia media, EnSubtitle subtitle) async {
    media = await _store.runInTransactionAsync<EnMedia, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<EnMedia>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        throw ArgumentError('mediaId $mediaId not existed');
      }
      final subtitleBox = store.box<EnSubtitle>();
      final sentenceBox = store.box<EnSentence>();
      final sentenceList = media.subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      sentenceBox.removeMany(sentenceList.map((s) => s.id).toList());
      subtitleBox.removeMany(media.subtitles.map((s) => s.id).toList());
      media.subtitles.clear();
      media.subtitles.add(subtitle);
      mediaBox.put(media);
      return media;
    }, media.id);
    return media;
  }

  Future<void> deleteMedia(EnMedia media) async {
    debugPrint(
      'before delete media(${media.id}):\nalbum(${media.albums.firstOrNull?.id}, ${media.albums.firstOrNull?.name})',
    );
    await _store.runInTransactionAsync<void, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<EnMedia>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        return;
      }
      final subtitleBox = store.box<EnSubtitle>();
      final sentenceBox = store.box<EnSentence>();
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
    debugPrint(
      'after delete media(${media.id}):\nalbum(${media.albums.firstOrNull?.id}, ${media.albums.firstOrNull?.name})',
    );
  }

  Future<EnMedia> deleteSubtitle(EnMedia media) async {
    if (media.subtitles.isEmpty) return media;
    media = await _store.runInTransactionAsync<EnMedia, int>(TxMode.write, (
      Store store,
      int mediaId,
    ) {
      final mediaBox = store.box<EnMedia>();
      final media = mediaBox.get(mediaId);
      if (media == null) {
        throw ArgumentError('mediaId $mediaId not existed');
      }
      final subtitleBox = store.box<EnSubtitle>();
      final sentenceBox = store.box<EnSentence>();
      final sentences = media.subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      sentenceBox.removeMany(sentences.map((s) => s.id).toList());
      subtitleBox.removeMany(media.subtitles.map((s) => s.id).toList());
      media.subtitles.clear();
      mediaBox.put(media);
      return media;
    }, media.id);
    return media;
  }

  Future<Directory> get _albumCoversDir async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory(p.join(appDir.path, 'album_covers'));
  }

  Future<String> _newAlbumCoverPath() async {
    final coversDir = await _albumCoversDir;
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    // Generate a unique filename using timestamp and original extension
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}';
    return p.join(coversDir.path, fileName);
  }

  Future<EnAlbum?> createAlbum(String name, {File? cover}) async {
    //校验 name
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    //保存封面
    final String? coverPath;
    if (cover != null) {
      coverPath = await _newAlbumCoverPath();
      await cover.copy(coverPath);
    } else {
      coverPath = null;
    }
    //获取 最大SortOrder
    final albumBox = _store.box<EnAlbum>();
    final query = albumBox
        .query()
        .order(EnAlbum_.sortOrder, flags: Order.descending)
        .build();
    final maxSortOrderAlbum = await query.findFirstAsync();
    query.close();

    final sortOrder = maxSortOrderAlbum != null
        ? maxSortOrderAlbum.sortOrder + 1
        : 0;
    return await _store.box<EnAlbum>().putAndGetAsync(
      EnAlbum(name: trimmedName, sortOrder: sortOrder, cover: coverPath, id: 0),
    );
  }

  Future<EnAlbum> updateAlbum(
    EnAlbum album, {
    String? name,
    File? Function()? cover,
  }) async {
    EnAlbum updatedAlbum = album.copyWith();
    if (name != null) {
      //update name
      final trimmedName = name.trim();
      if (trimmedName.isNotEmpty && trimmedName != album.name) {
        updatedAlbum = updatedAlbum.copyWith(name: trimmedName);
      }
    }
    if (cover != null) {
      //update cover
      final newCover = cover();
      if (newCover == null) {
        //remove cover
        updatedAlbum = await _deleteAlbumCoverFile(updatedAlbum);
      } else if (newCover.path != album.cover) {
        //update to newcover
        updatedAlbum = await _deleteAlbumCoverFile(updatedAlbum);
        final newCoverPath = await _newAlbumCoverPath();
        await newCover.copy(newCoverPath);
        updatedAlbum = updatedAlbum.copyWith(cover: () => newCoverPath);
      }
    }
    if (updatedAlbum.cover != album.cover || updatedAlbum.name != album.name) {
      return await _store.box<EnAlbum>().putAndGetAsync(updatedAlbum);
    } else {
      return album;
    }
  }

  Future<EnAlbum> _deleteAlbumCoverFile(EnAlbum album) async {
    if (album.cover != null) {
      final oldCover = File(album.cover!);
      if (await oldCover.exists()) {
        await oldCover.delete();
      }
      return album.copyWith(cover: () => null);
    } else {
      return album;
    }
  }

  Future<List<EnAlbum>> loadAlbums() async {
    final query = _store
        .box<EnAlbum>()
        .query()
        .order(EnAlbum_.sortOrder, flags: Order.descending)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  Future<EnAlbum?> loadAlbum(int id) async {
    final album = await _store.box<EnAlbum>().getAsync(id);
    album?.sortMedias();
    return album;
  }

  Future<(EnAlbum, EnAlbum)> swapAlbumsOrder(
    EnAlbum aAlbum,
    EnAlbum bAlbum,
  ) async {
    final aSortOrder = aAlbum.sortOrder;
    aAlbum = aAlbum.copyWith(sortOrder: bAlbum.sortOrder);
    bAlbum = bAlbum.copyWith(sortOrder: aSortOrder);
    await _store.box<EnAlbum>().putManyAsync([aAlbum, bAlbum]);
    return (aAlbum, bAlbum);
  }

  Future<void> deleteAlbum(EnAlbum album) async {
    await deleteAlbums([album]);
  }

  Future<void> deleteAlbums(List<EnAlbum> albums) async {
    if (albums.isEmpty) return;
    albums = albums.where((a) => a.id > 0).toList();

    await _store.runInTransactionAsync(TxMode.write, (
      Store store,
      List<int> albumIds,
    ) {
      final mediaBox = store.box<EnMedia>();
      final subtitleBox = store.box<EnSubtitle>();
      final sentenceBox = store.box<EnSentence>();
      final albumBox = store.box<EnAlbum>();

      final albumIdsSet = albumIds.toSet();
      final medias = mediaBox
          .getAll()
          .map((m) {
            m.albums.removeWhere((a) => albumIdsSet.contains(a.id));
            return m;
          })
          .where((m) => m.albums.isEmpty)
          .toList();
      final mediaIds = medias.map((m) => m.id).toList();
      final subtitles = medias
          .map((m) => m.subtitles)
          .expand((e) => e)
          .toList();
      final subtitleIds = subtitles.map((s) => s.id).toList();
      final sentences = subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      final sentenceIds = sentences.map((s) => s.id).toList();
      albumBox.removeMany(albumIds);
      mediaBox.removeMany(mediaIds);
      subtitleBox.removeMany(subtitleIds);
      sentenceBox.removeMany(sentenceIds);
    }, [for (final a in albums) a.id]);

    // Delete cover files for removed playlists
    final uselessCovers = albums
        .where((a) => a.cover != null)
        .map((a) => File(a.cover!));

    final removeCovers = uselessCovers.map((cover) async {
      if (await cover.exists()) {
        await cover.delete();
      }
    });
    await Future.wait(removeCovers);
  }

  Future<EnMedia?> loadMedia(int id) async {
    return await _store.box<EnMedia>().getAsync(id);
  }
}

extension on EnAlbum {
  void sortMedias() {
    medias.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
