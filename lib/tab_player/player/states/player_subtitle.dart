import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlayerSubtitle {
  final int? playingSentenceId;
  final int? loopIndex;
  final ItemScrollController scrollController;
  final List<int> sentenceIdList;

  const PlayerSubtitle({
    required this.sentenceIdList,
    required this.loopIndex,
    required this.playingSentenceId,
    required this.scrollController,
  });

  const PlayerSubtitle.empty(ItemScrollController scrollController)
    : this(
        scrollController: scrollController,
        loopIndex: null,
        playingSentenceId: null,
        sentenceIdList: const [],
      );

  PlayerSubtitle copyWith({
    List<int>? sentenceIdList,
    int? Function()? loopIndex,
    int? Function()? playingSentenceId,
  }) {
    return PlayerSubtitle(
      sentenceIdList: sentenceIdList ?? this.sentenceIdList,
      scrollController: scrollController,
      loopIndex: loopIndex == null ? this.loopIndex : loopIndex(),
      playingSentenceId: playingSentenceId == null
          ? this.playingSentenceId
          : playingSentenceId(),
    );
  }
}
