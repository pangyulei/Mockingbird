import 'package:mockingbird/db/entities/subtitle_entity.dart';

class PlayerSubtitleListState {
  final int? selectedIndex;
  final List<SubtitleEntity> subtitleList;
  const PlayerSubtitleListState(this.selectedIndex, this.subtitleList);

  const PlayerSubtitleListState.empty() : this(null, const []);
}
