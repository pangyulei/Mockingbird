
import 'dart:ui';

class SentenceCardState {
  final bool isPlaying;
  final String text;
  final String period;
  final int index;

  const SentenceCardState({
    this.text = '',
    this.period = '',
    this.isPlaying = false,
    this.index = 0,
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