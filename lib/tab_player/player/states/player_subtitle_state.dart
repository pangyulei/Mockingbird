sealed class PlayerSubtitleState {
  const PlayerSubtitleState();
}

class PlayerSubtitleEmpty extends PlayerSubtitleState {
  const PlayerSubtitleEmpty();
}

class PlayerSubtitleData extends PlayerSubtitleState {
  final List<String> sentenceIdList;

  const PlayerSubtitleData({required this.sentenceIdList});
}
