import 'package:mockingbird/tool/broadcaster.dart';

class UIAlbumsCardEvent extends BroadcastEvent {
  const UIAlbumsCardEvent();
}

class UIAlbumsCardEventOnEdit extends UIAlbumsCardEvent {
  final int index;
  const UIAlbumsCardEventOnEdit(this.index);
}

class UIAlbumsCardEventOnDelete extends UIAlbumsCardEvent {
  final int index;
  const UIAlbumsCardEventOnDelete(this.index);
}
class UIAlbumsCardEventOnTap extends UIAlbumsCardEvent {
  final int index;
  const UIAlbumsCardEventOnTap(this.index);
}
