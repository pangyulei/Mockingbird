import 'package:flutter/material.dart';

sealed class MediaCardEvent {
  const MediaCardEvent();
}

class MediaCardInitEvent extends MediaCardEvent {
  const MediaCardInitEvent();
}

class MediaCardClickEvent extends MediaCardEvent {
  final BuildContext context;
  final String mediaId;
  const MediaCardClickEvent(this.context, this.mediaId);
}
