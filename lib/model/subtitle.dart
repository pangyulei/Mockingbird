

import 'media.dart';
import 'sentence.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Subtitle {
  @Id()
  int id;

  @Backlink('subtitle')
  final sentences = ToMany<Sentence>();

  final media = ToOne<Media>();

  Subtitle({
    this.id = 0,
  });
}