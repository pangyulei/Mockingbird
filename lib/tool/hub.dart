import 'dart:async';

sealed class HubEvent {
  const HubEvent();
}


class Hub {
  static final _instance = Hub._();
  final _streamController = StreamController<HubEvent>.broadcast();

  Hub._();
  factory Hub() {
    return _instance;
  }

  void emit<T extends HubEvent>(T event) => _streamController.sink.add(event);

  StreamSubscription<T> on<T extends HubEvent>(void Function(T) f) {
    return _streamController.stream.where((e) => e is T).cast<T>().listen(f);
  }
}
