import 'package:mockingbird/models/playlist.dart';

class PlaylistDetailState {
  final Playlist? playlist;
  final bool showLoading;
  const PlaylistDetailState({this.playlist, this.showLoading = true});

  PlaylistDetailState copyWith({Playlist? playlist, bool? showLoading}) {
    return PlaylistDetailState(
      playlist: (playlist ?? this.playlist)?.copyWith(),
      showLoading: showLoading ?? this.showLoading,
    );
  }
}
