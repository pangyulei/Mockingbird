import 'package:flutter/widgets.dart';
import 'package:mockingbird/tool/event_hub.dart';

sealed class PlayerEvent {
  const PlayerEvent();
}

class PlayerInitEvent extends PlayerEvent {
  final String? mediaId;
  const PlayerInitEvent(this.mediaId);
}

class PlayerSyncFromBackgroundAudioEvent extends PlayerEvent {
  final BackgroundAudioInfo info;
  const PlayerSyncFromBackgroundAudioEvent(this.info);
}

class PlayerShowSubtitleListEvent extends PlayerEvent {
  const PlayerShowSubtitleListEvent();
}

class PlayerHideSubtitleListEvent extends PlayerEvent {
  const PlayerHideSubtitleListEvent();
}

class PlayerSubtitleChangeEvent extends PlayerEvent {
  final int index;
  const PlayerSubtitleChangeEvent(this.index);
}

class PlayerClickSentenceEvent extends PlayerEvent {
  final String sentenceId;
  const PlayerClickSentenceEvent(this.sentenceId);
}

class PlayerGoToAlbumListEvent extends PlayerEvent {
  final BuildContext context;
  const PlayerGoToAlbumListEvent(this.context);
}

class PlayerScrollToTopEvent extends PlayerEvent {
  const PlayerScrollToTopEvent();
}

class PlayerScrollToBottomEvent extends PlayerEvent {
  const PlayerScrollToBottomEvent();
}

class PlayerScrollToPlayingSentenceEvent extends PlayerEvent {
  const PlayerScrollToPlayingSentenceEvent();
}

class PlayerVolumeChangeEvent extends PlayerEvent {
  final double volume;
  const PlayerVolumeChangeEvent(this.volume);
}

class PlayerPositionChangeEvent extends PlayerEvent {
  final Duration position;
  const PlayerPositionChangeEvent(this.position);
}

class PlayerToggleVolumeEvent extends PlayerEvent {
  const PlayerToggleVolumeEvent();
}

class PlayerPauseEvent extends PlayerEvent {
  const PlayerPauseEvent();
}

class PlayerPlayEvent extends PlayerEvent {
  const PlayerPlayEvent();
}

class PlayerToggleLoopEvent extends PlayerEvent {
  const PlayerToggleLoopEvent();
}

class PlayerDecSpeedEvent extends PlayerEvent {
  const PlayerDecSpeedEvent();
}

class PlayerIncSpeedEvent extends PlayerEvent {
  const PlayerIncSpeedEvent();
}

class PlayerResetSpeedEvent extends PlayerEvent {
  const PlayerResetSpeedEvent();
}

class PlayerVideoSliderStartChangeEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerVideoSliderStartChangeEvent(this.position, this.duration);
}

class PlayerVideoSliderChangingEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerVideoSliderChangingEvent(this.position, this.duration);
}

class PlayerVideoSliderEndChangeEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerVideoSliderEndChangeEvent(this.position, this.duration);
}
