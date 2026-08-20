import 'dart:async';

import 'package:rxdart/rxdart.dart';

sealed class HubEvent {
  const HubEvent();
}

class HubPlayingSentenceChangedEvent extends HubEvent {
  final String playingSentenceId;
  const HubPlayingSentenceChangedEvent(this.playingSentenceId);
}

class EventHub {
  static final _behaviorSubject = BehaviorSubject<HubEvent>();
  static void emit(HubEvent event) => _behaviorSubject.add(event);
  static StreamSubscription<T> on<T extends HubEvent>(
    void Function(T event) f,
  ) => _behaviorSubject.stream.where((e) => e is T).cast<T>().listen(f);
}
