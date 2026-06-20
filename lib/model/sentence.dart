import 'package:mockingbird/model/subtitle.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Sentence {
  @Id()
  int id;

  final int startMicroseconds;
  final int endMicroseconds;
  final String text;
  final subtitle = ToOne<Subtitle>();

  Sentence({
    required this.startMicroseconds,
    required this.endMicroseconds,
    required this.text,
    this.id = 0,
  });

  Duration get start => Duration(microseconds: startMicroseconds);
  Duration get end => Duration(microseconds: endMicroseconds);
}
