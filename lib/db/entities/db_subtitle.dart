import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import 'db_media.dart';
import 'db_sentence.dart';

@Entity()
class DBSubtitle extends Equatable {
  @Id()
  int id;

  @Backlink('subtitle')
  final sentences = ToMany<DBSentence>();

  final media = ToOne<DBMedia>();

  DBSubtitle({required this.id});

  @override
  List<Object?> get props => [id];
}
