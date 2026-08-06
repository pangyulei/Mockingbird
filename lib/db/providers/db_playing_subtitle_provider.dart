import 'dart:io';

import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_subtitle_provider.g.dart';

@Riverpod(name: 'dbSubtitleProvider')
class DBPlayingSubtitle extends _$DBPlayingSubtitle {
  @override
  Future<SubtitleEntity?> build() async {
    //找到同目录下的名称对应上的srt或vtt字幕文件
    final mediaInfo = await (await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) async {
        final file = await st?.file;
        if (file == null) return null;
        return (file.path, file.parent);
      }),
    ));
    if (mediaInfo == null) return null;
    final (assetPath, parentDir) = mediaInfo;
    await for (final subFile in parentDir.list()) {
      if (subFile is! File) continue;
      final ext = p.extension(subFile.path); //带.
      if (!{'.srt', '.vtt'}.contains(ext)) continue;
      final subtitleName = p.basenameWithoutExtension(subFile.path);
      final assetName = p.basenameWithoutExtension(assetPath);
      if (subtitleName.contains(assetName)) {
        //matched
        SubtitleEntity? subtitleEntity = await SubtitleParser.parseFile(
          subFile,
        );
        return subtitleEntity;
      }
    }
    return null;
  }
}
