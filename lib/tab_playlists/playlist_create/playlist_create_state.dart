import 'dart:io';

class PlaylistCreateState {
  final File? cover;
  final bool creatable;
  final bool isCoverPressed;
  const PlaylistCreateState({
    this.cover,
    this.creatable = false,
    this.isCoverPressed = false,
  });

  PlaylistCreateState copyWith({
    File? cover,
    bool? creatable,
    bool? isCoverPressed,
  }) {
    return PlaylistCreateState(
      cover: cover ?? this.cover,
      creatable: creatable ?? this.creatable,
      isCoverPressed: isCoverPressed ?? this.isCoverPressed,
    );
  }
}
