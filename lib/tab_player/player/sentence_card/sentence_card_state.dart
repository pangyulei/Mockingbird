class SentenceCardState {
  final bool isFocused;
  final String text;
  final String period;

  const SentenceCardState({
    required this.text,
    required this.period,
    required this.isFocused,
  });

  const SentenceCardState.empty()
    : this(text: '', period: '', isFocused: false);

  SentenceCardState copyWith({
    bool? isFocused,
    String? text,
    String? period,
  }) {
    return SentenceCardState(
      isFocused: isFocused ?? this.isFocused,
      text: text ?? this.text,
      period: period ?? this.period,
    );
  }
}
