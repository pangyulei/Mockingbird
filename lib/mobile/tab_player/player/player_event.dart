import 'package:flutter/widgets.dart';

sealed class PlayerEvent {
  const PlayerEvent();
}

class PlayerInitEvent extends PlayerEvent {
  final String? mediaId;
  const PlayerInitEvent(this.mediaId);
}

class PlayerSyncFromBackgroundAudioEvent extends PlayerEvent {
  final Duration position;
  final bool playing;
  const PlayerSyncFromBackgroundAudioEvent({
    required this.position,
    required this.playing,
  });
}

class PlayerShowSubtitleListEvent extends PlayerEvent {
  const PlayerShowSubtitleListEvent();
}

class PlayerHideSubtitleListEvent extends PlayerEvent {
  const PlayerHideSubtitleListEvent();
}

class PlayerSelectAnotherSubtitleFromListEvent extends PlayerEvent {
  final String name;
  const PlayerSelectAnotherSubtitleFromListEvent(this.name);
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

class PlayerPositionChangeByPlayingEvent extends PlayerEvent {
  final Duration position;
  const PlayerPositionChangeByPlayingEvent(this.position);
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

class PlayerMediaSliderStartChangeEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerMediaSliderStartChangeEvent(this.position, this.duration);
}

class PlayerMediaSliderChangingEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerMediaSliderChangingEvent(this.position, this.duration);
}

class PlayerMediaSliderEndChangeEvent extends PlayerEvent {
  final Duration position;
  final Duration duration;
  const PlayerMediaSliderEndChangeEvent(this.position, this.duration);
}
