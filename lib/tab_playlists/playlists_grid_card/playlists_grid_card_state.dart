import 'package:mockingbird/model/album.dart';

class PlaylistsGridCardState {
  final bool isPressed;
  final Album playlist;
  const PlaylistsGridCardState({
    required this.playlist,
    this.isPressed = false
  });

  PlaylistsGridCardState copyWith({
    Album? playlist,
    bool? isPressed}) {
    return PlaylistsGridCardState(
      playlist: playlist ?? this.playlist,
      isPressed: isPressed ?? this.isPressed
    );
  }
}
