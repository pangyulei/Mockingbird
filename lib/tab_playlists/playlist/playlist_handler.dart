import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/objectbox.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/db/db_track.dart';
import 'package:mockingbird/models/track.dart';
import 'package:mockingbird/tab_playlists/playlist/playlist_events.dart';
import 'package:mockingbird/tab_playlists/playlist/playlist_state.dart';
import 'package:path/path.dart' as p;

class PlaylistHandler implements PlaylistEvents {
  const PlaylistHandler();

  @override
  Stream<PlaylistState> playlistWidgetInitState(int playlistId) async* {
    yield const PlaylistState(showLoading: true);
    final playlist = await DBPlaylist(
      ObjectBox.instance.store,
    ).getByIdAsync(playlistId);
    yield PlaylistState(playlist: playlist, showLoading: false);
  }

  @override
  Future<PlaylistState> playlistWidgetAddTracks(PlaylistState state) async {
    final playlist = state.playlist;
    if (playlist == null) {
      debugPrint('playlist not existed');
      return state;
    }
    try {
      final dbPlaylist = DBPlaylist(ObjectBox.instance.store);

      // Pick multiple audio/video files
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          //TODO only allow player supported formats
          // Audio formats
          'mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'wma',
          // Video formats
          'mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm',
        ],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return state; // User cancelled
      }

      // int nextSortOrder = playlist.tracks.length;
      //
      // for (final file in result.files) {
      //   if (file.path == null) continue;
      //
      //   final filePath = file.path!;
      //   final fileName = p.basename(filePath);
      //   final mediaType = DBTrack.getMediaTypeFromExtension(filePath);
      //
      //   // Auto-detect subtitle file
      //   final subtitlePath = DBTrack.findSubtitleFile(filePath);
      //
      //   final track = Track(
      //     id: 0, // Will be assigned by ObjectBox
      //     filePath: filePath,
      //     fileName: fileName,
      //     rawMediaType: mediaType.raw,
      //     sortOrder: nextSortOrder++,
      //     subtitlePath: subtitlePath,
      //   );
      //
      //   playlist.tracks.add(track);
      // }
      //
      // if (result.files.isNotEmpty) {
      //   await dbPlaylist.updateAsync(playlist);
      // }
      return state;

    } catch (e) {
      debugPrint('Error importing media files: $e');
      return state;

    } finally {

    }
  }
}
