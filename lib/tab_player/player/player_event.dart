sealed class PlayerEvent {
  const PlayerEvent();
}

class PlayerInitEvent extends PlayerEvent {
  const PlayerInitEvent();
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
