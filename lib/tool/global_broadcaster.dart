import 'dart:async';


abstract class BroadcastEvent {
  const BroadcastEvent();
}


class Broadcaster {
  static final _instance = Broadcaster._();
  final _streamController = StreamController<BroadcastEvent>.broadcast();
  
  Broadcaster._();
  factory Broadcaster() {
    return _instance;
  }

  void emit<T extends BroadcastEvent>(T event) => _streamController.add(event);

  StreamSubscription<T> on<T extends BroadcastEvent>(void Function(T) f) {
    return _streamController.stream.where((e) => e is T).cast<T>().listen(f);
  }
}
