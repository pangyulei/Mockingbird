
import 'dart:async';

import 'global_events.dart';


class GlobalBroadcaster {
  static final instance = GlobalBroadcaster._();
  GlobalBroadcaster._();
  final StreamController<GlobalEvent> _streamController = StreamController<GlobalEvent>.broadcast();
  void emit(GlobalEvent event) => _streamController.add(event);
  StreamSubscription<T> on<T extends GlobalEvent>(void Function(T) f) {
    return _streamController.stream.where((e) => e is T).cast<T>().listen(f);
  }
}