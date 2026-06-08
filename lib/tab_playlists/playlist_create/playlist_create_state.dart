import 'dart:io';

class PlaylistCreateState {
  final File? coverFile;
  final bool creatable;
  final bool isCoverPressed;
  const PlaylistCreateState({
    this.coverFile,
    this.creatable = false,
    this.isCoverPressed = false,
  });

  PlaylistCreateState copyWith({
    File? coverFile,
    bool? creatable,
    bool? isCoverPressed,
  }) {
    return PlaylistCreateState(
      coverFile: coverFile ?? this.coverFile,
      creatable: creatable ?? this.creatable,
      isCoverPressed: isCoverPressed ?? this.isCoverPressed,
    );
  }
}
