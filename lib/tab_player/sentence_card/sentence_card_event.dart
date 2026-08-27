import 'package:flutter/widgets.dart';

sealed class SentenceCardEvent {
  const SentenceCardEvent();
}

class SentenceCardInitEvent extends SentenceCardEvent {
  final bool playing;
  const SentenceCardInitEvent(this.playing);
}

class SentenceCardClickEvent extends SentenceCardEvent {
  final BuildContext context;
  const SentenceCardClickEvent(this.context);
}

class SentenceCardPlayingSentenceChangeEvent extends SentenceCardEvent {
  final String? playingSentenceId;
  const SentenceCardPlayingSentenceChangeEvent(this.playingSentenceId);
}
