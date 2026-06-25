import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_media.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:path/path.dart' as p;

import '../../model/album.dart';
import '../../model/media.dart';
import '../../tool/global_broadcaster.dart';
import '../../tool/subtitle_parser.dart';
import 'album_detail_interface_ui_events.dart';
import 'album_detail_state.dart';
import 'media_card/media_card_state.dart';


//TODO move
class GlobalEventPlayMedia extends BroadcastEvent {
  final Media media;
  const GlobalEventPlayMedia(this.media);
}


class AlbumDetailLogic implements AlbumDetailInterfaceUIEvents {
  Album? _album;
  final int _albumId;
  AlbumDetailLogic({required this._albumId});

  @override
  Stream<AlbumDetailState> albumDetailInitState() async* {
    yield const AlbumDetailState(showLoading: true);
    _album = await DBAlbum(DBObjectBox().store).get(_albumId);
    if (_album == null) {
      yield const AlbumDetailState(showLoading: false);
      return;
    }
    _album!.medias.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    yield _albumDetailState(_album!);
  }

  AlbumDetailState _albumDetailState(Album album) {
    return AlbumDetailState(
      showLoading: false,
      name: album.name,
      cover: album.cover == null ? null : File(album.cover!),
      mediaStates: album.medias.asMap().entries.map((e) {
        final m = e.value;
        return MediaCardState(
          name: m.name,
          type: m.type,
          hasSubtitle: m.subtitles.isNotEmpty,
          index: e.key,
        );
      }).toList(),
    );
  }

  @override
  Stream<AlbumDetailState> albumDetailImportMedias(
    AlbumDetailState state,
  ) async* {
    if (_album == null) {
      yield state.copyWith(showLoading: false);
      return;
    }
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
        yield state; // User cancelled
        return;
      }
      yield state.copyWith(showLoading: true);
      final files = pickedFiles.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();

      final List<File> videoFiles = [];
      final List<File> audioFiles = [];
      final List<File> subFiles = [];
      for (var f in files) {
        final ext = p.extension(f.path).replaceFirst('.', '').toLowerCase();
        if (kVideoExtensions.contains(ext)) videoFiles.add(f);
        if (kAudioExtensions.contains(ext)) audioFiles.add(f);
        if (kSubtitleExtensions.contains(ext)) subFiles.add(f);
      }

      // Match subtitles to medias
      final subtitleMap = {
        for (final f in subFiles) p.basenameWithoutExtension(f.path): f,
      };
      final readFiles = <({File media, File? subtitle})>[];
      for (File mediaFile in [...videoFiles, ...audioFiles]) {
        final mediaName = p.basenameWithoutExtension(mediaFile.path);
        // Find a subtitle file that contains the media name
        final matchedSubName = subtitleMap.keys.firstWhere(
          (name) => name.contains(mediaName),
          orElse: () => '',
        );
        final subFile = matchedSubName.isEmpty
            ? null
            : subtitleMap[matchedSubName];
        readFiles.add((media: mediaFile, subtitle: subFile));
      }

      await DBMedia(DBObjectBox().store).createMany(_album!, readFiles);
      _album!.medias.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      _album = await DBAlbum(DBObjectBox().store).get(_albumId);
      yield _albumDetailState(_album!);
    } catch (e) {
      debugPrint('Error importing media files: $e');
      yield state;
    }
  }

  @override
  void albumDetailPlayMedia(int index, BuildContext context) {
    if (_album == null) return;
    final media = _album!.medias[index];
    Broadcaster().emit(GlobalEventPlayMedia(media));
  }

  @override
  Stream<AlbumDetailState> albumDetailAddSubtitle(int index) async* {
    if (_album == null) return;
    final media = _album!.medias[index];

    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [...kSubtitleExtensions],
        allowMultiple: false,
      );

      if (pickedFiles == null ||
          pickedFiles.files.isEmpty ||
          pickedFiles.files.first.path == null) {
        return;
      }
      final platformFile = pickedFiles.files
          .where(
            (f) =>
                f.extension != null &&
                kSubtitleExtensions.contains(f.extension!),
          )
          .firstOrNull;
      if (platformFile == null) {
        return;
      }
      final subtitleFile = File(platformFile.path!);
      yield _albumDetailState(_album!).copyWith(showLoading: true);

      final subtitle = await SubtitleParser.parseFile(subtitleFile);

      // ObjectBox will handle the relation update.
      media.subtitles.add(subtitle);
      await DBMedia(DBObjectBox().store).update(media);

      _album = await DBAlbum(DBObjectBox().store).get(_albumId);
      yield _albumDetailState(_album!);
    } catch (e) {
      debugPrint('Error adding subtitle: $e');
      yield _albumDetailState(_album!);
    }
  }

  @override
  Stream<AlbumDetailState> albumDetailRemoveSubtitle(int index) async* {
    if (_album == null) return;
    final media = _album!.medias[index];
    yield _albumDetailState(_album!).copyWith(showLoading: true);
    await DBMedia(DBObjectBox().store).removeSubtitle(media);
    _album = await DBAlbum(DBObjectBox().store).get(_albumId);
    yield _albumDetailState(_album!);
  }

  @override
  Stream<AlbumDetailState> albumDetailDeleteMedia(int index) async* {
    if (_album == null) return;
    final media = _album!.medias[index];
    yield _albumDetailState(_album!).copyWith(showLoading: true);
    await DBMedia(DBObjectBox().store).remove(media);
    _album = await DBAlbum(DBObjectBox().store).get(_albumId);
    yield _albumDetailState(_album!);
  }
}
