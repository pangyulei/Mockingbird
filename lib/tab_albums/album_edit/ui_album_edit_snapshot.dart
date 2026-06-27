import 'dart:io';

import 'package:flutter/material.dart';

class UIAlbumEditSnapshot {
  final name = ValueNotifier<String>('');
  final cover = ValueNotifier<File?>(null);
  final enableSubmit = ValueNotifier<bool>(false);


  void dispose() {
    cover.dispose();
    enableSubmit.dispose();
  }
}
