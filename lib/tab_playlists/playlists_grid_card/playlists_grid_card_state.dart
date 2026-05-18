class PlaylistsGridCardState {
  final bool isPressed;

  const PlaylistsGridCardState({this.isPressed = false});

  PlaylistsGridCardState copyWith({bool? isPressed}) {
    return PlaylistsGridCardState(isPressed: isPressed ?? this.isPressed);
  }
}
