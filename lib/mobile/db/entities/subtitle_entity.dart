import 'package:mockingbird/mobile/db/entities/sentence_entity.dart';
import 'package:path/path.dart' as p;

class SubtitleEntity {
  final String path;
  final List<SentenceEntity> sentenceList;

  String get name => p.basename(path);

  const SubtitleEntity({required this.path, required this.sentenceList});
}
