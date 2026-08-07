
class SentenceEntity {
  final Duration start;
  final Duration end;
  final String text;

  SentenceEntity({
    required this.start,
    required this.end,
    required this.text,
  });

  @override
  String toString() {
    return text;
  }
}