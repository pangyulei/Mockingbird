import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'en_media.dart';
import 'en_sentence.dart';

@Entity()
class EnSubtitle extends Equatable {
  @Id()
  int id;

  @Backlink('subtitle')
  final sentences = ToMany<EnSentence>();

  final media = ToOne<EnMedia>();

  EnSubtitle({required this.id});

  @override
  List<Object?> get props => [id];
}
