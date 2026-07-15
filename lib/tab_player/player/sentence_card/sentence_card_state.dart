class SentenceCardState {
  final bool isPlaying;
  final String text;
  final String period;

  const SentenceCardState({
    required this.text,
    required this.period,
    required this.isPlaying,
  });

  const SentenceCardState.empty()
    : this(text: '', period: '', isPlaying: false);

  SentenceCardState copyWith({bool? isPlaying, String? text, String? period}) {
    return SentenceCardState(
      isPlaying: isPlaying ?? this.isPlaying,
      text: text ?? this.text,
      period: period ?? this.period,
    );
  }
}
