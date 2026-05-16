import 'package:mockingbird/models/playlist.dart';

class PlaylistState {
  final Playlist? playlist;
  final bool showLoading;
  const PlaylistState({this.playlist, this.showLoading = true});

  PlaylistState copyWith({Playlist? playlist, bool? showLoading}) {
    return PlaylistState(
      playlist: (playlist ?? this.playlist)?.copyWith(),
      showLoading: showLoading ?? this.showLoading,
    );
  }
}
