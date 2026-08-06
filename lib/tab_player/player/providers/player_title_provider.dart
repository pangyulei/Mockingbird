import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_title_provider.g.dart';

@riverpod
class PlayerTitle extends _$PlayerTitle {
  @override
  Future<String?> build() async {
    final assetTitle = (await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) async => await st?.titleAsync),
    ));
    return assetTitle;
  }
}
