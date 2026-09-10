import 'package:flutter/cupertino.dart';

sealed class PlayerSubtitleListEvent {
  const PlayerSubtitleListEvent();
}

class PlayerSubtitleListInitEvent extends PlayerSubtitleListEvent {
  const PlayerSubtitleListInitEvent();
}

class PlayerSubtitleListSelectNameEvent extends PlayerSubtitleListEvent {
  final String name;
  final BuildContext context;
  const PlayerSubtitleListSelectNameEvent(this.name, this.context);
}
