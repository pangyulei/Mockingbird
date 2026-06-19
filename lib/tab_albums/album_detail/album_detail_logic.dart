import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_media.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import '../../model/album.dart';
import '../../model/media.dart';
import '../../tool/global_broadcaster.dart';
import 'album_detail_interface_ui_events.dart';
import 'album_detail_state.dart';
import 'package:path/path.dart' as p;

import 'media_card_state.dart';

class AlbumDetailLogic implements AlbumDetailInterfaceUIEvents {
  Album? _album;
  final int _albumId;
  AlbumDetailLogic({required this._albumId});

  @override
  Stream<AlbumDetailState> albumDetailInitState() async* {
    yield const AlbumDetailState(showLoading: true);
    _album = await DBAlbum(DBObjectBox.instance.store).get(_albumId);
    if (_album == null) {
      yield const AlbumDetailState(showLoading: false);
      return;
    }
    _album!.medias.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    yield _albumDetailState(_album!);
  }

  AlbumDetailState _albumDetailState(Album album) {
    return AlbumDetailState(
      showLoading: false,
      name: album.name,
      cover: album.cover == null ? null : File(album.cover!),
      mediaStates: album.medias.map((m) => _mediaCardState(m)).toList(),
    );
  }

  MediaCardState _mediaCardState(Media m) {
    return MediaCardState(name: m.name, type: m.type, hasSubtitle: m.subtitle.target != null);
  }

  @override
  Stream<AlbumDetailState> albumDetailImportMedias(
      AlbumDetailState state) async* {
    if (_album == null) {
      yield state.copyWith(showLoading: false);
      return;
    }
    try {
      final allowedExtensions = [
        ...audioExtensions,
        ...videoExtensions,
        ...subtitleExtensions,
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
        if (videoExtensions.contains(ext)) videoFiles.add(f);
        if (audioExtensions.contains(ext)) audioFiles.add(f);
        if (subtitleExtensions.contains(ext)) subFiles.add(f);
      }

      // Match subtitles to medias
      final subtitleMap = {
        for (final f in subFiles) p.basenameWithoutExtension(f.path): f
      };
      final readFiles = <({File media, File? subtitle})>[];
      for (File mediaFile in [...videoFiles, ...audioFiles]) {
        final mediaName = p.basenameWithoutExtension(mediaFile.path);
        // Find a subtitle file that contains the media name
        final matchedSubName = subtitleMap.keys.firstWhere(
            (name) => name.contains(mediaName),
            orElse: () => '');
        final subFile =
            matchedSubName.isEmpty ? null : subtitleMap[matchedSubName];
        readFiles.add((media: mediaFile, subtitle: subFile));
      }

      await DBMedia(DBObjectBox.instance.store).createMany(_album!, readFiles);
      _album!.medias.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      yield _albumDetailState(_album!);

    } catch (e) {
      debugPrint('Error importing media files: $e');
      yield state;
    }
  }

  @override
  void albumDetailPlayMedia(Media media, BuildContext context) {
    GlobalBroadcaster.instance.emit(GlobalEventPlayMedia(media));
  }
}
