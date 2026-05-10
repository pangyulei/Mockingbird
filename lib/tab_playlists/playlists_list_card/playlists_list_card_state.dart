class PlaylistsListCardState {
  final bool isPressed;

  const PlaylistsListCardState({this.isPressed = false});

  PlaylistsListCardState copyWith({bool? isPressed}) {
    return PlaylistsListCardState(isPressed: isPressed ?? this.isPressed);
  }
}
