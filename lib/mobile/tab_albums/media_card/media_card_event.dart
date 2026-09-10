import 'package:flutter/material.dart';

sealed class MediaCardEvent {
  const MediaCardEvent();
}

class MediaCardInitEvent extends MediaCardEvent {
  const MediaCardInitEvent();
}

class MediaCardClickEvent extends MediaCardEvent {
  final BuildContext context;
  const MediaCardClickEvent(this.context);
}

class MediaCardPlayingMediaChangeEvent extends MediaCardEvent {
  final String? playingMediaId;
  const MediaCardPlayingMediaChangeEvent(this.playingMediaId);
}
