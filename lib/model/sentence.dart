import 'package:mockingbird/model/subtitle.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Sentence {
  @Id()
  int id;

  final int startMilliseconds;
  final int endMilliseconds;
  final String text;
  final subtitle = ToOne<Subtitle>();

  Sentence({
    required this.startMilliseconds,
    required this.endMilliseconds,
    required this.text,
    this.id = 0,
  });

  Duration get start => Duration(microseconds: startMilliseconds);
  Duration get end => Duration(microseconds: endMilliseconds);
}
