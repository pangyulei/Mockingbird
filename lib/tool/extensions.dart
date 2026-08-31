import 'dart:io';

import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

extension ObjectHelper on Object {
  T? as<T>() {
    return (this is T) ? (this as T) : null;
  }
}

extension IterableHelper<E> on Iterable<E> {
  int? firstIndexWhereOrNull(bool Function(E) test) {
    int i = 0;
    for (final element in this) {
      if (test(element)) {
        return i;
      }
      i++;
    }
    return null;
  }
}

extension ScrollHelper on ItemScrollController {
  void safeJumpTo(int? index, {double alignment = 0}) {
    if (isAttached && index != null) {
      // debugPrint('${identityHashCode(this)} will jump to index $index');
      jumpTo(index: index, alignment: alignment);
    } else {
      // debugPrint(
      //   '${identityHashCode(this)} jump fail, attached $isAttached, index $index',
      // );
    }
  }

  void safeScrollTo(
    int? index, {
    double alignment = 0,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    if (isAttached && index != null) {
      // debugPrint(
      //   '${identityHashCode(this)} will scroll to index $index align $alignment',
      // );
      scrollTo(index: index, duration: duration, alignment: alignment);
    } else {
      // debugPrint(
      //   '${identityHashCode(this)} scroll fail, attached $isAttached, index $index',
      // );
    }
  }
}

extension AssetEntityHelper on AssetEntity {
  Future<List<SubtitleEntity>> get subtitleList async {
    //找到同目录下的名称对应上的srt或vtt字幕文件
    final mediaFile = await file;
    if (mediaFile == null) return [];
    final subtitleList = <SubtitleEntity>[];
    await for (final subFile in mediaFile.parent.list()) {
      if (subFile is! File) continue;
      final extension = p.extension(subFile.path); //带.
      if (!{'.srt', '.vtt'}.contains(extension)) continue;
      final subtitleName = p.basenameWithoutExtension(subFile.path);
      final mediaName = p.basenameWithoutExtension(mediaFile.path);
      final matched = subtitleName.toLowerCase().contains(
        mediaName.toLowerCase(),
      );
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
