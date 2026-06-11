import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mockingbird/db/db_playlist.dart';
import 'package:mockingbird/db/db_track.dart';
import 'package:mockingbird/db/objectbox.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_interface_ui_events.dart';
import '../../models/track.dart';
import 'playlist_detail_state.dart';
import 'package:path/path.dart' as p;

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
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          ...audioExtensions,
          ...videoExtensions,
          ...subtitleExtensions,
        ],
        allowMultiple: true,
      );

      if (pickedFiles == null || pickedFiles.files.isEmpty) {
        return state; // User cancelled
      }
      final files = pickedFiles.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();

      final videoFiles = files
          .where((f) => TrackType.fromFile(f) == TrackType.video)
          .toList();
      final audioFiles = files
          .where((f) => TrackType.fromFile(f) == TrackType.audio)
          .toList();
      final subFiles = files
          .where((f) => subtitleExtensions.contains(
              p.extension(f.path).replaceFirst('.', '').toLowerCase()))
          .toList();

      //match subtitles to tracks
      final subFileMap = {
        for (final f in subFiles) p.basenameWithoutExtension(f.path): f
      };
      List<({File trackFile, File? subFile})> relatedFiles = [];
      for (File trackFile in [...videoFiles, ...audioFiles]) {
        final trackName = p.basenameWithoutExtension(trackFile.path);
        final matchedSubName = subFileMap.keys.firstWhere(
            (name) => name.contains(trackName),
            orElse: () => "");
        final subFile =
            matchedSubName.isEmpty ? null : subFileMap[matchedSubName];
        relatedFiles.add((trackFile: trackFile, subFile: subFile));
      }

      // Save tracks to disk and DB
      final newTracks =
          await DBTrack(ObjectBox.instance.store).createMany(relatedFiles);

      // Combine existing and new tracks, then sort
      playlist.tracks.addAll(newTracks);
      playlist.tracks.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      await DBPlaylist(ObjectBox.instance.store).update(playlist);
      return state;

    } catch (e) {
      debugPrint('Error importing media files: $e');
      return state;
    } finally {}
  }
}
