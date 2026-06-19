import 'package:flutter/cupertino.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/album_detail_state.dart';

import '../../model/media.dart';

abstract interface class AlbumDetailInterfaceUIEvents {
  Stream<AlbumDetailState> albumDetailInitState();

  /// Import audio/video files to the playlist
  Stream<AlbumDetailState> albumDetailImportMedias(AlbumDetailState state);

  /// Trigger playing a media
  void albumDetailPlayMedia(Media media, BuildContext context);
}
