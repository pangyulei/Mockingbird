import 'dart:io';

class EditAlbumState {
  final String title;
  final String submitTitle;
  final File? cover;
  final bool enableSubmit;
  final String name;

  const EditAlbumState({
    required this.name,
    required this.title,
    required this.submitTitle,
    required this.cover,
    required this.enableSubmit,
  });

  const EditAlbumState.add()
    : this(
        title: 'Create Album',
        submitTitle: 'Create',
        cover: null,
        enableSubmit: false,
        name: '',
      );

  const EditAlbumState.edit(String name, File? cover)
    : this(
        title: 'Edit Album',
        submitTitle: 'Save',
        cover: cover,
        enableSubmit: false,
        name: name,
      );

  EditAlbumState copyWith({String? name,bool? enableSubmit, File? Function()? cover}) {
    return EditAlbumState(
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      enableSubmit: enableSubmit ?? this.enableSubmit,
      title: title,
      submitTitle: submitTitle,
    );
  }
}
