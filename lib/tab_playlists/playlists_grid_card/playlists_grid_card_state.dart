import 'package:mockingbird/models/playlist.dart';

class PlaylistsGridCardState {
  final bool isPressed;
  final Playlist playlist;
  const PlaylistsGridCardState({
    required this.playlist,
    this.isPressed = false
  });

  PlaylistsGridCardState copyWith({
    Playlist? playlist,
    bool? isPressed}) {
    return PlaylistsGridCardState(
      playlist: playlist ?? this.playlist,
      isPressed: isPressed ?? this.isPressed
    );
  }
}
