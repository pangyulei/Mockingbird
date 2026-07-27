import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../db/entities/en_subtitle.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  @override
  Future<PlayerSubtitleState> build() async {
    final sentenceList = await ref.watch(
      dbPlayingMediaProvider.selectAsync(
        (st) => st?.subtitleList.firstOrNull?.sentenceList,
      ),
    );

    if (sentenceList == null || sentenceList.isEmpty) {
      return const PlayerSubtitleNull();
    }
    return PlayerSubtitleData(sentenceList: sentenceList);
  }

}
