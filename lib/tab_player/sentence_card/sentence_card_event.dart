import 'package:flutter/widgets.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';

sealed class SentenceCardEvent {
  const SentenceCardEvent();
}

class SentenceCardInitEvent extends SentenceCardEvent {
  final SentenceEntity? sentence;
  final bool playing;
  const SentenceCardInitEvent(this.sentence, this.playing);
}

class SentenceCardClickEvent extends SentenceCardEvent {
  final BuildContext context;
  const SentenceCardClickEvent(this.context);
}

class SentenceCardPlayingSentenceChangedEvent extends SentenceCardEvent {
  final String? playingSentenceId;
  const SentenceCardPlayingSentenceChangedEvent(this.playingSentenceId);
}
