import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PlayerSubtitle {
  final int? playingSentenceId;
  final ItemScrollController scrollController;
  final List<int> sentenceIdList;

  const PlayerSubtitle({
    required this.sentenceIdList,
    required this.playingSentenceId,
    required this.scrollController,
  });

  const PlayerSubtitle.empty(ItemScrollController scrollController)
    : this(
        scrollController: scrollController,
        playingSentenceId: null,
        sentenceIdList: const [],
      );

  PlayerSubtitle copyWith({
    List<int>? sentenceIdList,
    int? Function()? playingSentenceId,
  }) {
    return PlayerSubtitle(
      sentenceIdList: sentenceIdList ?? this.sentenceIdList,
      scrollController: scrollController,
      playingSentenceId: playingSentenceId == null
          ? this.playingSentenceId
          : playingSentenceId(),
    );
  }
}
