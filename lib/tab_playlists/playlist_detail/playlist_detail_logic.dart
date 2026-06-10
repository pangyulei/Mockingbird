import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/db/db_track.dart';
import 'package:mockingbird/db/objectbox.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_interface_ui_events.dart';
import 'playlist_detail_state.dart';

class PlaylistDetailLogic implements PlaylistDetailInterfaceUIEvents {
  const PlaylistDetailLogic();

  @override
  Stream<PlaylistDetailState> playlistDetailInitState(int playlistId) async* {
    yield const PlaylistDetailState(showLoading: true);
    final playlist = await DBPlaylist(
      ObjectBox.instance.store,
    ).getById(playlistId);
    yield PlaylistDetailState(playlist: playlist, showLoading: false);
  }

  @override
  Future<PlaylistDetailState> playlistDetailAddTracks(
      PlaylistDetailState state) async {
    final playlist = state.playlist;
    if (playlist == null) {
      debugPrint('playlist not existed');
      return state;
    }
    try {
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
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          //TODO only allow player supported formats
          ...audioExtensions,
          ...videoExtensions,
        ],
        allowMultiple: true,
      );

      if (pickedFiles == null || pickedFiles.files.isEmpty) {
        return state; // User cancelled
      }
      final files = pickedFiles.files.where((f) => f.path != null).map((f) =>
          File(f.path!)).toList();
      final tracks = await DBTrack(ObjectBox.instance.store).createMany(files);
      playlist.tracks.addAll(tracks);

      // Ascend sort tracks by track's name
      final allTracks = playlist.tracks.toList();
      allTracks.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      final newPlaylist = playlist.copyWith(tracks: allTracks);
      await DBPlaylist(ObjectBox.instance.store).update(newPlaylist);
      return state.copyWith(playlist: newPlaylist);

    } catch (e) {
      debugPrint('Error importing media files: $e');
      return state;
    } finally {}
  }
}