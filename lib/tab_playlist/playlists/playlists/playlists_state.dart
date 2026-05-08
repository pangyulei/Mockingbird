

import 'package:mockingbird/models/playlist.dart';

class PlaylistsState {
  final List<Playlist> playlists;
  final bool isLoadingAll;
  const PlaylistsState(this.playlists, {this.isLoadingAll = true});
}