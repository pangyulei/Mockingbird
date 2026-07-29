import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/en_sentence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'db_sentence_provider.g.dart';

@Riverpod(name:'dbSentenceProvider')
class DBSentence extends _$DBSentence {
  @override
  Future<EnSentence?> build(int? id) async {
    return await DBLogic().loadSentence(id);
  }
}