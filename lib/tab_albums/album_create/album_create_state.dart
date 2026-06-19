import 'dart:io';

class AlbumCreateState {
  final File? coverFile;
  final bool creatable;
  final bool isCoverPressed;
  const AlbumCreateState({
    this.coverFile,
    this.creatable = false,
    this.isCoverPressed = false,
  });

  AlbumCreateState copyWith({
    File? coverFile,
    bool? creatable,
    bool? isCoverPressed,
  }) {
    return AlbumCreateState(
      coverFile: coverFile ?? this.coverFile,
      creatable: creatable ?? this.creatable,
      isCoverPressed: isCoverPressed ?? this.isCoverPressed,
    );
  }
}
