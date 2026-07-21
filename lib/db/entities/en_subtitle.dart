import 'package:objectbox/objectbox.dart';

import 'en_media.dart';
import 'en_sentence.dart';

@Entity()
class EnSubtitle {
  @Id()
  int id;

  @Backlink('subtitle')
  final sentenceList = ToMany<EnSentence>();

  final media = ToOne<EnMedia>();

  EnSubtitle({required this.id});
}
