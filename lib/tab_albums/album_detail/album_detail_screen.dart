import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart'; // 👈 确保顶部导了这个包
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_media.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/model/media.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'album_detail_state.dart';

class AlbumDetailScreen extends StatefulWidget {
  final int _albumId;
  const AlbumDetailScreen(this._albumId, {super.key});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen>
    implements AlbumDetailUIOutputITF {
  var _state = const AlbumDetailState.empty();
  Album? _album;
  // final _subs = <StreamSubscription>[];

  @override
  Widget build(BuildContext context) {
    return AlbumDetailUI(_state, this);
  }

  // @override
  // void dispose() {
  //   _cancelAllSubs();
  //   super.dispose();
  // }

  // void _cancelAllSubs() {
  //   for (final sub in _subs) {
  //     sub.cancel();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _state = _state.copyWith(showLoading: true);
    _reloadAlbumById();
  }

  // void _observeAlbum() {
  // final albumBox = DBObjectBox().store.box<Album>();
  // final albumStream = albumBox
  //     .query(Album_.id.equals(widget._albumId))
  //     .watch(triggerImmediately: true)
  //     .map((q) async => await q.findFirstAsync());
  // final sub = albumStream.listen((event) async {
  //   final album = await event;
  //   _reloadAlbum(album);
  // });
  // _subs.add(sub);
  // }

  Future<void> _reloadAlbumById() async {
    _album = await DBAlbum(DBObjectBox().store).get(widget._albumId);
    setState(() {
      _state = _createStateByAlbum(_album);
    });
  }

  AlbumDetailState _createStateByAlbum(Album? album) {
    if (album == null) return const AlbumDetailState.empty();
    album.medias.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    final mediaStates = album.medias.asMap().entries.map((e) {
      final index = e.key;
      final media = e.value;
      return MediaCardState(
        name: media.name,
        type: media.type,
        hasSubtitle: media.subtitles.isNotEmpty,
        index: index,
      );
    }).toList();
    return AlbumDetailState(
      showImport: true,
      showLoading: false,
      name: album.name,
      cover: album.cover == null ? null : File(album.cover!),
      mediaStates: mediaStates,
    );
  }

  @override
  void albumDetail_onImportMedias() async {
    final album = _album;
    if (album == null) {
      debugPrint('album==null, can NOT import medias');
      return;
    }
    Future<List<File>> pickFiles() async {
      try {
        final allowedExtensions = [
          ...kAudioExtensions,
          ...kVideoExtensions,
          ...kSubtitleExtensions,
        ];
        final pickedFiles = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedExtensions,
          allowMultiple: true,
        );

        if (pickedFiles == null || pickedFiles.files.isEmpty) {
          return [];
        }
        final files = pickedFiles.files
            .where((f) => f.path != null)
            .map((f) => File(f.path!))
            .toList();
        return files;
      } catch (e) {
        debugPrint('Error importing media files: $e');
        return [];
      }
    }

    final List<File> videoFiles = [];
    final List<File> audioFiles = [];
    final List<File> subtitleFiles = [];
    final files = await pickFiles();
    for (var f in files) {
      final ext = p.extension(f.path).replaceFirst('.', '').toLowerCase();
      if (kVideoExtensions.contains(ext)) videoFiles.add(f);
      if (kAudioExtensions.contains(ext)) audioFiles.add(f);
      if (kSubtitleExtensions.contains(ext)) subtitleFiles.add(f);
    }

    // Match subtitles to medias
    final subtitleMap = {
      for (final f in subtitleFiles) p.basenameWithoutExtension(f.path): f,
    };
    final matchedFiles = <({File media, File? subtitle})>[];
    for (File mediaFile in [...videoFiles, ...audioFiles]) {
      final mediaName = p.basenameWithoutExtension(mediaFile.path);
      // Find a subtitle file that contains the media name
      final matchedSubtitleName = subtitleMap.keys.firstWhereOrNull(
        (subtitleName) => subtitleName.contains(mediaName));
      final subtitleFile = matchedSubtitleName == null ? null : subtitleMap[matchedSubtitleName];
      matchedFiles.add((media: mediaFile, subtitle: subtitleFile));
    }
    if (matchedFiles.isEmpty) {
      debugPrint('no picked videos, no picked audios');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    await DBMedia(DBObjectBox().store).createMany(album, matchedFiles);
    await _reloadAlbumById();
  }

  @override
  void mediaCard_onAddSubtitle(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album == null, can NOT add any subtitle');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('no media at index $index, can NOT add any subtitle');
      return;
    }
    Future<String?> pickSubtitle() async {
      try {
        final pickedFiles = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: [...kSubtitleExtensions],
          allowMultiple: false,
        );
        // if (pickedFiles == null ||
        //     pickedFiles.files.isEmpty ||
        //     pickedFiles.files.first.path == null) {
        //   return;
        // }
        final subtitlePath = pickedFiles?.files.firstWhereOrNull(
          (f) => kSubtitleExtensions.contains(f.extension?.toLowerCase() ?? ''),
        )?.path;
        return subtitlePath;
      } catch (e) {
        debugPrint('Error adding subtitle: $e');
        return null;
      }
    }
    final subtitlePath = await pickSubtitle();
    if (subtitlePath == null) {
      debugPrint('no subtitle files picked');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    final subtitleFile = File(subtitlePath);
    final subtitle = await SubtitleParser.parseFile(subtitleFile);
    await DBMedia(DBObjectBox().store).addSubtitle(media, subtitle);
    await _reloadAlbumById();
}

  @override
  void mediaCard_onDeleteMedia(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    await DBMedia(DBObjectBox().store).remove(media);
    await _reloadAlbumById();
  }

  @override
  void mediaCard_onPlayMedia(int index) {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    context.go(AppRoute.playerById(media.id));
  }

  @override
  void mediaCard_onRemoveSubtitle(int index) async {
    final album = _album;
    if (album == null) {
      debugPrint('album==null');
      return;
    }
    final media = album.medias.elementAtOrNull(index);
    if (media == null) {
      debugPrint('media==null at index $index');
      return;
    }
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    await DBMedia(DBObjectBox().store).removeSubtitle(media);
    await _reloadAlbumById();
  }
}
