
import 'dart:ui';

class SentenceCardState {
  final bool isPlaying;
  final String text;
  final String period;
  final int index;

  const SentenceCardState({
    required this.text,
    required this.period,
    required this.isPlaying,
    required this.index,
  });

  SentenceCardState copyWith({
    bool? isPlaying,
    String? text,
    String? period,
    int? index,
  }) {
    return SentenceCardState(
      isPlaying: isPlaying ?? this.isPlaying,
      text: text ?? this.text,
      period: period ?? this.period,
      index: index ?? this.index,
    );
  }

}