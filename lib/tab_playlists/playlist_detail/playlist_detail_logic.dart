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
  Stream<PlaylistDetailState> playlistDetailAddTracks(
      PlaylistDetailState state) async* {
    var playlist = state.playlist;
    if (playlist == null) {
      debugPrint('playlist not existed');
      yield state;
      return;
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
        yield state; // User cancelled
        return;
      }
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

      // Match subtitles to tracks
      final subFileMap = {
        for (final f in subFiles) p.basenameWithoutExtension(f.path): f
      };
      List<({File trackFile, File? subFile})> relatedFiles = [];
      for (File trackFile in [...videoFiles, ...audioFiles]) {
        final trackName = p.basenameWithoutExtension(trackFile.path);
        // Find a subtitle file that contains the track name
        final matchedSubName = subFileMap.keys.firstWhere(
            (name) => name.contains(trackName),
            orElse: () => "");
        final subFile =
            matchedSubName.isEmpty ? null : subFileMap[matchedSubName];
        relatedFiles.add((trackFile: trackFile, subFile: subFile));
      }
      yield state.copyWith(showLoading: true);
      // Save tracks to disk and DB
      final tracks =
          await DBTrack(ObjectBox.instance.store).createMany(relatedFiles);

      // Add to playlist relationship
      playlist.tracks.addAll(tracks);
      final dbPlaylist = DBPlaylist(ObjectBox.instance.store);
      await dbPlaylist.update(playlist);

      // Fetch updated playlist to ensure everything is synced
      playlist = (await dbPlaylist.getById(playlist.id))!;

      // Sort tracks by name ascending
      playlist.tracks.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      yield state.copyWith(playlist: playlist, showLoading: false);
    } catch (e) {
      debugPrint('Error importing media files: $e');
      yield state;
    }
  }
}
