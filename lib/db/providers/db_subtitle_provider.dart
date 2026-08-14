import 'package:collection/collection.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_playing_subtitle_list_provider.dart';

part 'db_subtitle_provider.g.dart';

@Riverpod(name: 'dbSubtitleProvider')
class DBSubtitle extends _$DBSubtitle {
  @override
  Future<SubtitleEntity?> build(String? name) async {
    if (name == null) return null;
    final subtitleList = await ref.watch(dbPlayingSubtitleListProvider.future);
    return subtitleList.firstWhereOrNull((s) => s.name == name);
  }
}
