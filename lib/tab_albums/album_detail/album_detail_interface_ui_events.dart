import 'package:flutter/cupertino.dart';

import 'album_detail_state.dart';

abstract interface class AlbumDetailInterfaceUIEvents {
  Stream<AlbumDetailState> albumDetailInitState();

  /// Import audio/video files to the playlist
  Stream<AlbumDetailState> albumDetailImportMedias(AlbumDetailState state);

  /// Trigger playing a media
  void albumDetailPlayMedia(int index, BuildContext context);

  /// Add or change subtitle for a media
  Stream<AlbumDetailState> albumDetailAddSubtitle(int index);

  /// Remove subtitle from a media
  Stream<AlbumDetailState> albumDetailRemoveSubtitle(int index);

  /// Delete a media
  Stream<AlbumDetailState> albumDetailDeleteMedia(int index);
}
