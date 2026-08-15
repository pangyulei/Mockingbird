import 'package:flutter/material.dart';

sealed class MediaCardEvent {
  const MediaCardEvent();
}

class MediaCardLoadingEvent extends MediaCardEvent {
  const MediaCardLoadingEvent();
}

class MediaCardClickEvent extends MediaCardEvent {
  final BuildContext context;
  const MediaCardClickEvent(this.context);
}
