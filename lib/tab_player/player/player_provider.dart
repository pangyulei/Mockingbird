import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_provider.g.dart';

// name:'playingProvider'
@Riverpod(keepAlive: true)
class Player extends _$Player {
  @override
  Future<PlayerState?> build(int id) async {
    final media = await ref.watch(dbMediaProvider(id).future);
    return null;
  }
}

