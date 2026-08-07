
import 'package:mockingbird/db/entities/sentence_entity.dart';

class SubtitleEntity {
  final String name;
  final List<SentenceEntity> sentenceList;
  SubtitleEntity({required this.name, required this.sentenceList});
}