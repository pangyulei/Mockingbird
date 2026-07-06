import 'dart:io';

class EditAlbumState {
  final bool showLoading;
  final String title;
  final String submitTitle;
  final File? cover;
  final bool enableSubmit;

  const EditAlbumState({
    required this.showLoading,
    required this.title,
    required this.submitTitle,
    required this.cover,
    required this.enableSubmit,
  });

  const EditAlbumState.empty()
    : this(
        title: '',
        submitTitle: '',
        cover: null,
        enableSubmit: false,
        showLoading: false,
      );

  EditAlbumState copyWith({
    bool? showLoading,
    String? title,
    String? submitTitle,
    bool? enableSubmit,
    File? Function()? cover,
  }) {
    return EditAlbumState(
      showLoading: showLoading ?? this.showLoading,
      title: title ?? this.title,
      submitTitle: submitTitle ?? this.submitTitle,
      cover: cover == null ? this.cover : cover(),
      enableSubmit: enableSubmit ?? this.enableSubmit,
    );
  }
}
