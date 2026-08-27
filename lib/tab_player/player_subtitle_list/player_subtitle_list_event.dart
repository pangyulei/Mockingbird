import 'package:flutter/cupertino.dart';

sealed class PlayerSubtitleListEvent {
  const PlayerSubtitleListEvent();
}

class PlayerSubtitleListInitEvent extends PlayerSubtitleListEvent {
  const PlayerSubtitleListInitEvent();
}

class PlayerSubtitleListSelectIndexEvent extends PlayerSubtitleListEvent {
  final int index;
  final BuildContext context;
  const PlayerSubtitleListSelectIndexEvent(this.index, this.context);
}
