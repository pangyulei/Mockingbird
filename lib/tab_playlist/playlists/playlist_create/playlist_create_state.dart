
import 'dart:io';

class PlaylistCreateState {
  final File? cover;
  final bool creatable;
  const PlaylistCreateState({this.cover, this.creatable = false});

  PlaylistCreateState copyWith({
    File? cover,
    bool? creatable,
  }) {
    return PlaylistCreateState(
      cover: cover ?? this.cover,
      creatable: creatable ?? this.creatable,
    );
  }
}