import 'package:mockingbird/db/entities/db_subtitle.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBSentence {
  @Id()
  int id;

  final int startMicroseconds;
  final int endMicroseconds;
  final String text;
  final subtitle = ToOne<DBSubtitle>();

  DBSentence({
    required this.startMicroseconds,
    required this.endMicroseconds,
    required this.text,
    required this.id,
  });

  Duration get start => Duration(microseconds: startMicroseconds);
  Duration get end => Duration(microseconds: endMicroseconds);
}
