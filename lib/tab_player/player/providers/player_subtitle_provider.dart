import 'package:mockingbird/db/providers/db_playing_subtitle_provider.dart';
import 'package:mockingbird/tab_player/player/states/player_subtitle_state.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_subtitle_provider.g.dart';

@riverpod
class PlayerSubtitle extends _$PlayerSubtitle {
  @override
  Future<PlayerSubtitleState> build() async {
    //找到同目录下的名称对应上的srt或vtt字幕文件
    final subtitleEntity = await ref.watch(dbSubtitleProvider.future);
    if (subtitleEntity == null) return const PlayerSubtitleNull();
    return PlayerSubtitleData(
      sentenceStateList: subtitleEntity.sentenceList
          .map(
            (sen) => SentenceCardState(
              text: sen.text,
              period: '${sen.start.timeString} - ${sen.end.timeString}',
              playing: false,
            ),
          )
          .toList(),
    );
  }
}

extension on Duration {
  String get timeString {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
