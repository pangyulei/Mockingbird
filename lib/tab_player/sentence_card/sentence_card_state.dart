class SentenceCardState {
  final bool playing;
  final String text;
  final String period;

  const SentenceCardState({
    required this.text,
    required this.period,
    required this.playing,
  });
  const SentenceCardState.empty() : this(playing: false, period: '', text: '');

  SentenceCardState copyWith({bool? playing, String? text, String? period}) {
    return SentenceCardState(
      playing: playing ?? this.playing,
      text: text ?? this.text,
      period: period ?? this.period,
    );
  }
}
