
import 'dart:async';

import '../model/media.dart';

abstract class GlobalEvent {
  const GlobalEvent();
}

class GlobalEventPlayMedia extends GlobalEvent {
  final Media media;
  const GlobalEventPlayMedia(this.media);
}

class GlobalBroadcaster {
  static final instance = GlobalBroadcaster._();
  GlobalBroadcaster._();
  final StreamController<GlobalEvent> _streamController = StreamController<GlobalEvent>.broadcast();
  void emit(GlobalEvent event) => _streamController.add(event);
  StreamSubscription<T> on<T extends GlobalEvent>(void Function(T) f) {
    return _streamController.stream.where((e) => e is T).cast<T>().listen(f);
  }
}