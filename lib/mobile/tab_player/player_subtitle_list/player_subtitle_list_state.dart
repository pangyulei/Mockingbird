import 'package:mockingbird/mobile/db/entities/subtitle_entity.dart';

class PlayerSubtitleListState {
  final String? selectedSubtitleName;
  final List<SubtitleEntity> subtitleList;

  const PlayerSubtitleListState(this.selectedSubtitleName, this.subtitleList);

  const PlayerSubtitleListState.empty() : this(null, const []);
}
