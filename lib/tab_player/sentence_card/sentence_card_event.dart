import 'package:flutter/widgets.dart';

sealed class SentenceCardEvent {
  const SentenceCardEvent();
}

class SentenceCardInitEvent extends SentenceCardEvent {
  const SentenceCardInitEvent();
}

class SentenceCardClickEvent extends SentenceCardEvent {
  final BuildContext context;
  const SentenceCardClickEvent(this.context);
}

class SentenceCardPlayingSentenceChangedEvent extends SentenceCardEvent {
  final String? playingSentenceId;
  const SentenceCardPlayingSentenceChangedEvent(this.playingSentenceId);
}
