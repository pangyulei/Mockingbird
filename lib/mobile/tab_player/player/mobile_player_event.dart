import 'package:flutter/widgets.dart';

sealed class MobilePlayerEvent {
  const MobilePlayerEvent();
}

class MobilePlayerInitEvent extends MobilePlayerEvent {
  final String? mediaId;
  const MobilePlayerInitEvent(this.mediaId);
}

class MobilePlayerSyncFromBackgroundAudioEvent extends MobilePlayerEvent {
  final Duration position;
  final bool playing;
  const MobilePlayerSyncFromBackgroundAudioEvent({
    required this.position,
    required this.playing,
  });
}

class MobilePlayerShowSubtitleListEvent extends MobilePlayerEvent {
  const MobilePlayerShowSubtitleListEvent();
}

class MobilePlayerHideSubtitleListEvent extends MobilePlayerEvent {
  const MobilePlayerHideSubtitleListEvent();
}

class MobilePlayerSelectAnotherSubtitleFromListEvent extends MobilePlayerEvent {
  final String name;
  const MobilePlayerSelectAnotherSubtitleFromListEvent(this.name);
}

class MobilePlayerClickSentenceEvent extends MobilePlayerEvent {
  final String sentenceId;
  const MobilePlayerClickSentenceEvent(this.sentenceId);
}

class MobilePlayerGoToAlbumListEvent extends MobilePlayerEvent {
  final BuildContext context;
  const MobilePlayerGoToAlbumListEvent(this.context);
}

class MobilePlayerScrollToTopEvent extends MobilePlayerEvent {
  const MobilePlayerScrollToTopEvent();
}

class MobilePlayerScrollToBottomEvent extends MobilePlayerEvent {
  const MobilePlayerScrollToBottomEvent();
}

class MobilePlayerScrollToPlayingSentenceEvent extends MobilePlayerEvent {
  const MobilePlayerScrollToPlayingSentenceEvent();
}

class MobilePlayerVolumeChangeEvent extends MobilePlayerEvent {
  final double volume;
  const MobilePlayerVolumeChangeEvent(this.volume);
}

class MobilePlayerPositionChangeByPlayingEvent extends MobilePlayerEvent {
  final Duration position;
  const MobilePlayerPositionChangeByPlayingEvent(this.position);
}

class MobilePlayerToggleVolumeEvent extends MobilePlayerEvent {
  const MobilePlayerToggleVolumeEvent();
}

class MobilePlayerPauseEvent extends MobilePlayerEvent {
  const MobilePlayerPauseEvent();
}

class MobilePlayerPlayEvent extends MobilePlayerEvent {
  const MobilePlayerPlayEvent();
}

class MobilePlayerToggleLoopEvent extends MobilePlayerEvent {
  const MobilePlayerToggleLoopEvent();
}

class MobilePlayerDecSpeedEvent extends MobilePlayerEvent {
  const MobilePlayerDecSpeedEvent();
}

class MobilePlayerIncSpeedEvent extends MobilePlayerEvent {
  const MobilePlayerIncSpeedEvent();
}

class MobilePlayerResetSpeedEvent extends MobilePlayerEvent {
  const MobilePlayerResetSpeedEvent();
}

class MobilePlayerMediaSliderStartChangeEvent extends MobilePlayerEvent {
  final Duration position;
  final Duration duration;
  const MobilePlayerMediaSliderStartChangeEvent(this.position, this.duration);
}

class MobilePlayerMediaSliderChangingEvent extends MobilePlayerEvent {
  final Duration position;
  final Duration duration;
  const MobilePlayerMediaSliderChangingEvent(this.position, this.duration);
}

class MobilePlayerMediaSliderEndChangeEvent extends MobilePlayerEvent {
  final Duration position;
  final Duration duration;
  const MobilePlayerMediaSliderEndChangeEvent(this.position, this.duration);
}
