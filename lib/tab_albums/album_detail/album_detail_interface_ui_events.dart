import 'package:flutter/cupertino.dart';
import '../../model/media.dart';
import 'album_detail_state.dart';

abstract interface class AlbumDetailInterfaceUIEvents {
  Stream<AlbumDetailState> albumDetailInitState();

  /// Import audio/video files to the playlist
  Stream<AlbumDetailState> albumDetailImportMedias(AlbumDetailState state);

  /// Trigger playing a media
  void albumDetailPlayMedia(Media media, BuildContext context);
}
