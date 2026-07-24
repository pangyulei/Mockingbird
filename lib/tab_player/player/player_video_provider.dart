//seperate with videocontroller provider, so if you update media's name or its subtitle,
//the videocontroller wont rebuild
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_subtitle.dart';
import 'package:mockingbird/db/providers/db_playing_media_provider.dart';
import 'package:mockingbird/db/providers/db_pref_provider.dart';
import 'package:mockingbird/tab_player/player/player_video.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';


final playerVideoProvider = AsyncNotifierProvider.autoDispose(
  PlayerVideoNotifier.new,
);

class PlayerVideoNotifier extends AsyncNotifier<PlayerVideo?> {
  final _scrollController = ItemScrollController();
  @override
  Future<PlayerVideo?> build() async {
    //because of this is read and have to await, this has to be a AsyncNotifier
    final VideoPlayerController? videoController = await ref.watch(
      playerVideoControllerProvider.future,
    );
    if (videoController == null) return null;
    final EnSubtitle? subtitle = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.subtitleList.firstOrNull),
    );
    final isLoop = await ref.read(
      dbPrefProvider.selectAsync((pref) => pref.isLoop),
    );
    final int? loopingIndex;
    final sentenceList = subtitle?.sentenceList;
    if (isLoop) {
      //maybe no subtitle, try to set first sentence as loopIndex
      loopingIndex = (sentenceList == null || sentenceList.isEmpty) ? null : 0;
    } else {
      loopingIndex = null;
    }
    final playingSentenceId = (sentenceList == null || sentenceList.isEmpty)
        ? null
        : sentenceList.first.id;
    _scrollController.safeJumpTo(0);
    return PlayerVideo(
      sentenceIdList: sentenceList?.map((sen) => sen.id).toList() ?? [],
      scrollController: _scrollController,
      playingSentenceId: playingSentenceId,
      positionMicro: 0,
      showVolumeSlider: false,
      videoController: videoController,
      isPlaying: true,
      speed: 1,
      volume: 1,
      loopIndex: loopingIndex,
    );
  }
}

final playerVideoControllerProvider = AsyncNotifierProvider(
  PlayerVideoController.new,
);

class PlayerVideoController extends AsyncNotifier<VideoPlayerController?> {
  @override
  Future<VideoPlayerController?> build() async {
    // final String? path = (await ref.watch(dbPlayingMediaProvider.future))?.path;
    final String? path = await ref.watch(
      dbPlayingMediaProvider.selectAsync((st) => st?.path),
    );
    if (path == null || path.isEmpty) return null;
    final videoController = VideoPlayerController.file(File(path));
    ref.onDispose(() {
      videoController.dispose();
    });
    //its neccessary to await initialize, otherwise aspectratio etc will wrong
    await videoController.initialize();
    await videoController.play();
    return videoController;
  }
}
