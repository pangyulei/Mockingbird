class PlaylistCardState {
  final bool isPressed;

  const PlaylistCardState({this.isPressed = false});

  PlaylistCardState copyWith({
    bool? isPressed,
  }) {
    return PlaylistCardState(
      isPressed: isPressed ?? this.isPressed,
    );
  }
}
