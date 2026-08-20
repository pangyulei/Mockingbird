import 'package:flutter/material.dart';

sealed class AlbumCardEvent {
  const AlbumCardEvent();
}

class AlbumCardInitEvent extends AlbumCardEvent {
  const AlbumCardInitEvent();
}

class AlbumCardClickEvent extends AlbumCardEvent {
  final BuildContext context;
  const AlbumCardClickEvent(this.context);
}
