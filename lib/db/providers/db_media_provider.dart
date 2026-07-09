import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/db/entities/db_media.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'db_media_provider.g.dart';

@Riverpod(name: 'dbMediaAsyncProvider')
class DBMediaAsync extends _$DBMediaAsync {
  @override
  Future<DBMedia?> build(int id) async {
    return await DBLogic().loadMedia(id);
  }
}
