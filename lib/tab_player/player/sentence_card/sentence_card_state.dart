class SentenceCardState {
  final bool isFocused;
  final String text;
  final String period;
  final int index;

  const SentenceCardState({
    required this.text,
    required this.period,
    required this.isFocused,
    required this.index,
  });

  const SentenceCardState.empty()
    : this(text: '', period: '', isFocused: false, index: 0);

  SentenceCardState copyWith({
    bool? isFocused,
    String? text,
    String? period,
    int? index,
  }) {
    return SentenceCardState(
      isFocused: isFocused ?? this.isFocused,
      text: text ?? this.text,
      period: period ?? this.period,
      index: index ?? this.index,
    );
  }
}
