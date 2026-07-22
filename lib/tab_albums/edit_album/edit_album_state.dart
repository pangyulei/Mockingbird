import 'dart:io';

import 'package:flutter/material.dart';

class EditAlbumState {
  final String title;
  final String submitTitle;

  final TextEditingController nameController;
  final File? cover;
  final bool enableSubmit;

  const EditAlbumState({
    required this.nameController,
    required this.title,
    required this.submitTitle,
    required this.cover,
    required this.enableSubmit,
  });

  const EditAlbumState.add(TextEditingController nameController)
    : this(
        nameController: nameController,
        title: 'Create Album',
        submitTitle: 'Create',
        cover: null,
        enableSubmit: false,
      );

  const EditAlbumState.edit(
    File? cover,
    TextEditingController nameController,
  ) : this(
        nameController: nameController,
        title: 'Edit Album',
        submitTitle: 'Save',
        cover: cover,
        enableSubmit: false,
      );

  EditAlbumState copyWith({
    bool? enableSubmit,
    File? Function()? getCover,
  }) {
    return EditAlbumState(
      cover: getCover == null ? cover : getCover(),
      enableSubmit: enableSubmit ?? this.enableSubmit,
      title: title,
      submitTitle: submitTitle,
      nameController: nameController,
    );
  }
}
