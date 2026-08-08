
import 'package:mockingbird/db/entities/sentence_entity.dart';

class SubtitleEntity {
  final String id;
  final String name;
  final List<SentenceEntity> sentenceList;
  const SubtitleEntity({required this.id,required this.name, required this.sentenceList});
}