import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';

sealed class PlayerSubtitleState {
  const PlayerSubtitleState();
}

class PlayerSubtitleNull extends PlayerSubtitleState {
  const PlayerSubtitleNull();
}

class PlayerSubtitleData extends PlayerSubtitleState {
  final List<SentenceCardState> sentenceStateList;

  const PlayerSubtitleData({required this.sentenceStateList});

}
