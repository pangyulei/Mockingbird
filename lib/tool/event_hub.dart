import 'dart:async';

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

class HubAppInactiveEvent extends HubEvent {
  const HubAppInactiveEvent();
}

class HubAppResumeEvent extends HubEvent {
  const HubAppResumeEvent();
}

class EventHub {
  static final _behaviorSubject = BehaviorSubject<HubEvent>();

  static void emit(HubEvent event) => _behaviorSubject.add(event);

  static StreamSubscription<T> on<T extends HubEvent>(void Function(T event) f) =>
      _behaviorSubject.stream.where((e) => e is T).cast<T>().listen(f);
}
