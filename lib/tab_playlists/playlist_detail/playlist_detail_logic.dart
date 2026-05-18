import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/db/objectbox.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_interface_ui_events.dart';

import '../../models/track.dart';
import 'playlist_detail_state.dart';

class PlaylistDetailLogic implements PlaylistDetailInterfaceUIEvents {
  const PlaylistDetailLogic();

  @override
  Stream<PlaylistDetailState> initState(int playlistId) async* {
    yield const PlaylistDetailState(showLoading: true);
    final playlist = await DBPlaylist(
      ObjectBox.instance.store,
    ).getById(playlistId);
    yield PlaylistDetailState(playlist: playlist, showLoading: false);
  }

  @override
  Future<PlaylistDetailState> addTracks(PlaylistDetailState state) async {
    final playlist = state.playlist;
    if (playlist == null) {
      debugPrint('playlist not existed');
      return state;
    }
    try {
      final dbPlaylist = DBPlaylist(ObjectBox.instance.store);

      // Pick multiple audio/video files
      const audioExtensions = [
        'mp3',
        'wav',
        'aac',
        'm4a',
        'flac',
        'ogg',
        'wma',
      ];
      const videoExtensions = [
        'mp4',
        'avi',
        'mkv',
        'mov',
        'wmv',
        'flv',
        'webm',
      ];
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          //TODO only allow player supported formats
          ...audioExtensions,
          ...videoExtensions,
        ],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return state; // User cancelled
      }

      //TODO sort by name
      for (final file in result.files) {
        if (file.path == null || file.extension == null) continue;
        final type = audioExtensions.contains(file.extension!)
            ? TrackType.audio
            : TrackType.video;
        // Auto-detect subtitle file
        final subtitlePathStr = _getSameNameSubtitlePathStr(
          file.path!,
          file.extension!,
        );
        final track = Track(
          pathStr: file.path!,
          name: file.name,
          rawType: type.raw,
          subtitlePathStr: subtitlePathStr,
        );
        playlist.tracks.add(track);
      }

      if (result.files.isNotEmpty) {
        await dbPlaylist.update(playlist);
      }
      return state;
    } catch (e) {
      debugPrint('Error importing media files: $e');
      return state;
    } finally {}
  }

  String? _getSameNameSubtitlePathStr(String pathStr, String extension) {
    const subtitleExtensions = ['.srt', '.vtt', '.sub', '.ass'];
    for (final subtitleExtension in subtitleExtensions) {
      final extensionRangeStart = pathStr.length - extension.length;
      final subtitlePathStr = pathStr.replaceRange(
        extensionRangeStart,
        pathStr.length,
        subtitleExtension,
      );
      if (File(subtitlePathStr).existsSync()) {
        return subtitlePathStr;
      }
    }
    return null;
  }
}
