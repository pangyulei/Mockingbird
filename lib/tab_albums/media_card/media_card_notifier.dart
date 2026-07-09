import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'media_card_notifier.g.dart';

// class MediaCardNotifier extends Notifier<MediaCardState> {
//   @override
//   MediaCardState build() {
//     ref.onDispose(
//       () => debugPrint('MediaCardNotifier ${identityHashCode(this)} disposed'),
//     );
//     //ref.watch, ref.listen are ok
//     return const MediaCardState.empty();
//   }
// }

// final provider = NotifierProvider.autoDispose(MediaCardNotifier.new);

@Riverpod(keepAlive: false)
class MediaCard extends _$MediaCard {
  @override
  MediaCardState build(int i) {
    return const MediaCardState.empty();
  }
}
