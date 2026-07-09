import 'dart:io';

class EditAlbumState {
  final String title;
  final String submitTitle;
  final String name;
  final File? cover;
  final bool enableSubmit;

  const EditAlbumState({
    required this.name,
    required this.title,
    required this.submitTitle,
    required this.cover,
    required this.enableSubmit,
  });

  const EditAlbumState.empty()
    : this(
        cover: null,
        enableSubmit: false,
        name: '',
        submitTitle: '',
        title: '',
      );

  const EditAlbumState.create()
    : this(
        name: '',
        title: 'Create Album',
        submitTitle: 'Create',
        cover: null,
        enableSubmit: false,
      );
  const EditAlbumState.edit(String name, File? cover)
    : this(
        name: name,
        title: 'Edit Album',
        submitTitle: 'Save',
        cover: cover,
        enableSubmit: false,
      );

  EditAlbumState copyWith({
    String? name,
    String? title,
    String? submitTitle,
    bool? enableSubmit,
    File? Function()? cover,
  }) {
    return EditAlbumState(
      title: title ?? this.title,
      name: name ?? this.name,
      submitTitle: submitTitle ?? this.submitTitle,
      cover: cover == null ? this.cover : cover(),
      enableSubmit: enableSubmit ?? this.enableSubmit,
    );
  }
}
