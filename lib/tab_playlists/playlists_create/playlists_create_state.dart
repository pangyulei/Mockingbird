import 'dart:io';

class PlaylistsCreateState {
  final File? cover;
  final bool creatable;
  final bool isCoverPressed;
  const PlaylistsCreateState({
    this.cover,
    this.creatable = false,
    this.isCoverPressed = false,
  });

  PlaylistsCreateState copyWith({
    File? cover,
    bool? creatable,
    bool? isCoverPressed,
  }) {
    return PlaylistsCreateState(
      cover: cover ?? this.cover,
      creatable: creatable ?? this.creatable,
      isCoverPressed: isCoverPressed ?? this.isCoverPressed,
    );
  }
}
