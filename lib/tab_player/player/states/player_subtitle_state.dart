import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlayerSubtitleState {
  final int? playingSentenceId;
  final ItemScrollController scrollController;
  final List<int> sentenceIdList;

  const PlayerSubtitleState({
    required this.sentenceIdList,
    required this.playingSentenceId,
    required this.scrollController,
  });

  const PlayerSubtitleState.empty(ItemScrollController scrollController)
    : this(
        scrollController: scrollController,
        playingSentenceId: null,
        sentenceIdList: const [],
      );

  PlayerSubtitleState copyWith({
    List<int>? sentenceIdList,
    int? Function()? playingSentenceId,
  }) {
    return PlayerSubtitleState(
      sentenceIdList: sentenceIdList ?? this.sentenceIdList,
      scrollController: scrollController,
      playingSentenceId: playingSentenceId == null
          ? this.playingSentenceId
          : playingSentenceId(),
    );
  }
}
