import 'dart:io';

import 'package:flutter/material.dart';

sealed class EditAlbumState {
  const EditAlbumState();
}

class EditAlbumData extends EditAlbumState {
  final String title;
  final String submitTitle;

  final TextEditingController nameController;
  final File? cover;
  final bool enableSubmit;

  const EditAlbumData({
    required this.nameController,
    required this.title,
    required this.submitTitle,
    required this.cover,
    required this.enableSubmit,
  });

  const EditAlbumData.add(TextEditingController nameController)
    : this(
        nameController: nameController,
        title: 'Create Album',
        submitTitle: 'Create',
        cover: null,
        enableSubmit: false,
      );

  const EditAlbumData.edit(File? cover, TextEditingController nameController)
    : this(
        nameController: nameController,
        title: 'Edit Album',
        submitTitle: 'Save',
        cover: cover,
        enableSubmit: false,
      );

  EditAlbumData copyWith({bool? enableSubmit, File? Function()? cover}) {
    return EditAlbumData(
      cover: cover == null ? this.cover : cover(),
      enableSubmit: enableSubmit ?? this.enableSubmit,
      title: title,
      submitTitle: submitTitle,
      nameController: nameController,
    );
  }
}
