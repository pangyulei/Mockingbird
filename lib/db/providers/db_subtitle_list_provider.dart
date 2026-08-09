import 'dart:io';

import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entities/subtitle_entity.dart';

part 'db_subtitle_list_provider.g.dart';

@Riverpod(name: 'dbSubtitleListProvider')
class DBSubtitleList extends _$DBSubtitleList {
  @override
  Future<List<SubtitleEntity>> build() async {
    //找到同目录下的名称对应上的srt或vtt字幕文件
    final subtitleList = <SubtitleEntity>[];
    final mediaInfo = await (await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) async {
        final file = await st?.file;
        if (file == null) return null;
        return (file.path, file.parent);
      }),
    ));
    if (mediaInfo == null) return subtitleList;
    final (mediaPath, parentDir) = mediaInfo;
    await for (final subFile in parentDir.list()) {
      if (subFile is! File) continue;
      final extension = p.extension(subFile.path); //带.
      if (!{'.srt', '.vtt'}.contains(extension)) continue;
      final subtitleName = p.basenameWithoutExtension(subFile.path);
      final mediaName = p.basenameWithoutExtension(mediaPath);
      final matched = subtitleName.toLowerCase().contains(mediaName.toLowerCase());
      if (matched) {
        final subtitleEntity = await SubtitleParser.parseFile(subFile);
        if (subtitleEntity != null) {
          subtitleList.add(subtitleEntity);
        }
      }
    }
    return subtitleList;
  }
}
