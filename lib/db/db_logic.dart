import 'dart:io';
import 'package:collection/collection.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef MF_SF = ({File mediaFile, File? subtitleFile});
typedef M_SF = ({Media media, File subtitleFile});

class DBLogic {
  final Store _store;
  const DBLogic.test(this._store); //for unit test
  DBLogic() : this.test(DBObjectBox().store);

  ({List<MF_SF> mfsfList, List<M_SF> msfList}) _processMediaSubtitleFiles(
    List<Media> albumMedias,
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

  Future<List<Media>> _mediasMadeFromMFSFList(
    Album album,
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
      final media = Media(
        path: dirMediaFile.path,
        name: mediaName,
        id: 0,
        versionId: 0,
      );
      media.albums.add(album);
      final subtitle = subtitlesWithoutId[i];
      if ((subtitle != null)) {
        media.subtitles.add(subtitle);
      }
      return media;
    }).toList();
    return mediasWithoutId;
  }

  Future<List<Media>> _mediasFilledSubtitleFromMSFList(
    Album album,
    List<M_SF> msfList,
  ) async {
    if (msfList.isEmpty) return [];
    final makeSubtitles = msfList
        .map((msf) => msf.subtitleFile)
        .map((sf) => SubtitleParser.parseFile(sf));
    final subtitlesWithoutId = await Future.wait(makeSubtitles);
    final mediasFilledSubtitle = msfList.asMap().entries.map((e) {
      int i = e.key;
      final media = e.value.media.incVersion();
      final subtitleWithoutId = subtitlesWithoutId[i];
      media.subtitles.clear();
      media.subtitles.add(subtitleWithoutId);
      return media;
    }).toList();
    return mediasFilledSubtitle;
  }

  Future<List<Media>> importMediaAndSubtitles(
    Album album,
    List<File> files,
  ) async {
    final (:mfsfList, :msfList) = _processMediaSubtitleFiles(
      album.medias,
      files,
    );
    final mediasMade = await _mediasMadeFromMFSFList(album, mfsfList);
    final mediasFilled = await _mediasFilledSubtitleFromMSFList(album, msfList);
    final medias = await _store.box<Media>().putAndGetManyAsync([
      ...mediasMade,
      ...mediasFilled,
    ]);
    return medias;
  }
}
