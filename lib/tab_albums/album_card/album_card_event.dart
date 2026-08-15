import 'package:flutter/material.dart';

sealed class AlbumCardEvent {
  const AlbumCardEvent();
}

class AlbumCardLoadingEvent extends AlbumCardEvent {
  const AlbumCardLoadingEvent();
}

class AlbumCardClickEvent extends AlbumCardEvent {
  final BuildContext context;
  const AlbumCardClickEvent(this.context);
}
