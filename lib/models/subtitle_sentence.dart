class SubtitleSentence {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleSentence({
    required this.start,
    required this.end,
    required this.text,
  });

  @override
  String toString() => 'SubtitleSentence(start: $start, end: $end, text: $text)';
}
