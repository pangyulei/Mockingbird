import 'package:mockingbird/db/entities/en_sentence.dart';

sealed class PlayerSubtitleState {
  const PlayerSubtitleState();
}

class PlayerSubtitleNull extends PlayerSubtitleState {
  const PlayerSubtitleNull();
}

class PlayerSubtitleData extends PlayerSubtitleState {
  final List<EnSentence> sentenceList;

  const PlayerSubtitleData({
    required this.sentenceList,
  });

  PlayerSubtitleData copyWith({
    List<EnSentence>? sentenceList,
  }) {
    return PlayerSubtitleData(
      sentenceList: sentenceList ?? this.sentenceList,
    );
  }
}
