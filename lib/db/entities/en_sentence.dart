import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class EnSentence {
  @Id()
  int id;

  final int startMicroseconds;
  final int endMicroseconds;
  final String text;
  final subtitle = ToOne<EnSubtitle>();

  EnSentence({
    required this.startMicroseconds,
    required this.endMicroseconds,
    required this.text,
    required this.id,
  });

  Duration get start => Duration(microseconds: startMicroseconds);
  Duration get end => Duration(microseconds: endMicroseconds);
}
