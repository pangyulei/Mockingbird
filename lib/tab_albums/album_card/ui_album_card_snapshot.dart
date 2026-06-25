import 'package:flutter/material.dart';

class UIAlbumCardSnapshot {
  int index = 0;
  final cover = ValueNotifier<String?>(null);
  final mediasCount = ValueNotifier<int>(0);
  final name = ValueNotifier<String>('');
  final animatedScale = ValueNotifier<double>(1);

  void dispose() {
    cover.dispose();
    name.dispose();
    mediasCount.dispose();
    animatedScale.dispose();
  }
}
