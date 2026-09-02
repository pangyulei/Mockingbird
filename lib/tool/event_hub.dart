import 'dart:async';

import 'package:photo_manager/photo_manager.dart';
import 'package:rxdart/rxdart.dart';

sealed class HubEvent {
  const HubEvent();
}

class HubPlayMediaEvent extends HubEvent {
  final String? playingMediaId;

  const HubPlayMediaEvent(this.playingMediaId);
}

class HubPlayingSentenceChangeEvent extends HubEvent {
  final String? playingSentenceId;

  const HubPlayingSentenceChangeEvent(this.playingSentenceId);
}

class HubSubtitleChangeEvent extends HubEvent {
  final int index;

  const HubSubtitleChangeEvent(this.index);
}


class PlayerMediaInfo {
  final AssetEntity media;
  final bool playing;
  final Duration position;
  final Duration duration;
  final double speed;
  final double volume;
  const PlayerMediaInfo({
    required this.media,
    required this.volume,
    required this.playing,
    required this.position,
    required this.duration,
    required this.speed,
  });
}

class HubSyncPlayerToBackgroundAudioEvent extends HubEvent {
  final PlayerMediaInfo? info;
  const HubSyncPlayerToBackgroundAudioEvent(this.info);
}

class HubSyncBackgroundAudioToPlayerEvent extends HubEvent {
  final bool playing;
  final Duration position;
  const HubSyncBackgroundAudioToPlayerEvent({
    required this.playing,
    required this.position,
  });
}

class HubAppPauseEvent extends HubEvent {
  const HubAppPauseEvent();
}

class HubAppResumeEvent extends HubEvent {
  const HubAppResumeEvent();
}

class EventHub {
  static final _behaviorSubject = BehaviorSubject<HubEvent>();

  static void emit(HubEvent event) => _behaviorSubject.add(event);

  static StreamSubscription<T> on<T extends HubEvent>(
    void Function(T event) f,
  ) => _behaviorSubject.stream.where((e) => e is T).cast<T>().listen(f);
}
