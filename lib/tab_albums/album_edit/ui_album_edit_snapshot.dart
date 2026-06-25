import 'dart:io';

import 'package:flutter/material.dart';

class UIAlbumEditSnapshot {
  final title = ValueNotifier<String>('');
  final name = ValueNotifier<String>('');
  final submitTitle = ValueNotifier<String>('');
  final cover = ValueNotifier<File?>(null);
  final enableSubmit = ValueNotifier<bool>(false);

  void dispose() {
    cover.dispose();
    title.dispose();
    submitTitle.dispose();
    enableSubmit.dispose();
  }
}
