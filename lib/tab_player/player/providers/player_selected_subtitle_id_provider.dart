import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_selected_subtitle_id_provider.g.dart';
@riverpod
class PlayerSelectedSubtitleId extends _$PlayerSelectedSubtitleId {
  @override
  String? build() {
    return null;
  }
  void selectId(String? id) {
    state = id;
  }
}