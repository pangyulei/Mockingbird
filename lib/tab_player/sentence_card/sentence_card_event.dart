sealed class SentenceCardEvent {
  const SentenceCardEvent();
}

class SentenceCardInitEvent extends SentenceCardEvent {
  const SentenceCardInitEvent();
}

class SentenceCardPlayingSentenceChangedEvent extends SentenceCardEvent {
  final String playingSentenceId;
  const SentenceCardPlayingSentenceChangedEvent(this.playingSentenceId);
}
