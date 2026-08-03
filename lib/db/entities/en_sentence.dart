import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class EnSentence {
  @Id()
  int id;

  final int start_ms;
  final int end_ms;
  final String text;
  final subtitle = ToOne<EnSubtitle>();

  EnSentence({
    required this.start_ms, //TODO upgrade to start_ms in milliseconds
    required this.end_ms,
    required this.text,
    required this.id,
  });

  Duration get start => Duration(milliseconds: start_ms);

  Duration get end => Duration(milliseconds: end_ms);

  @override
  String toString() {
    return text;
  }
}
