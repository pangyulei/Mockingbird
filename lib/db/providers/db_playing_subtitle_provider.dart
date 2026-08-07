import 'dart:io';

import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/db/providers/db_playing_subtitle_list_provider.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_playing_subtitle_provider.g.dart';

@Riverpod(name: 'dbPlayingSubtitleProvider')
class DBPlayingSubtitle extends _$DBPlayingSubtitle {
  @override
  Future<SubtitleEntity?> build() async {
    final subtitleList = await ref.watch(dbPlayingSubtitleListProvider.future);
    return subtitleList.firstOrNull;
  }
}
