

import 'package:equatable/equatable.dart';
import 'media.dart';
import 'sentence.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Subtitle extends Equatable {
  @Id()
  int id;

  @Backlink('subtitle')
  final sentences = ToMany<Sentence>();

  final media = ToOne<Media>();

  Subtitle({
    required this.id,
  });
  
  @override
  List<Object?> get props => [id];
}