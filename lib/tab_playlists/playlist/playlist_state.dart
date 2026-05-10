import 'package:mockingbird/models/playlist.dart';

class PlaylistState {
  final Playlist? playlist;
  final bool showLoading;
  const PlaylistState({this.playlist, this.showLoading = true});
}
