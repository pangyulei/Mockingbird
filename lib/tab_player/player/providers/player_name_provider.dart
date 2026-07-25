import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';



final playerNameProvider = NotifierProvider.autoDispose(PlayerNameNotifier.new);
class PlayerNameNotifier extends Notifier<String> {
  @override
  String build() {
    final String mediaName =
        ref.watch(dbPlayingMediaProvider.select((st) => st.value?.name ?? ''));
    return mediaName;
  }
}
