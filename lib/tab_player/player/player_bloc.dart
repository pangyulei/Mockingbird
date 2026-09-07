import 'dart:async';

import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/entities/media_progress_entity.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/tab_player/player/player_event.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tab_player/player/player_ui.dart';
import 'package:mockingbird/tab_player/player_subtitle_list/player_subtitle_list_bloc.dart';
import 'package:mockingbird/tab_player/player_subtitle_list/player_subtitle_list_ui.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_bloc.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_event.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_ui.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../db/db.dart';

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.2;
const double _kStepPlaySpeed = 0.1;

class SharedPlayerBloc {
  static final instance = PlayerBloc();
}

typedef PositionUpdated = ({
  bool mediaCompleted,
  SentenceEntity? completedLoopSentence,
  bool sentenceChanged,
});

class PlayerBloc extends PlayerBlocType {
  bool _mediaPlayingBeforeDrag = false;
  AssetEntity? _media;

  SpotType? get _spot {
    final state = this.state;
    if (state is! PlayerDataState) return null;
    final sentenceList = state.selectedSubtitle?.sentenceList;
    final position = state.position;
    return sentenceList?.spot(position);
  }

  SpotType? _prevSpot;

  final _subscriptionList = <StreamSubscription>[];

  PlayerBloc() : super(const PlayerInitState()) {
    debugPrint('player bloc ${identityHashCode(this)} created');
    on<PlayerInitEvent>(_onInit);
    on<PlayerSelectAnotherSubtitleFromListEvent>(_onSelectAnotherSubtitleFromList);
    on<PlayerShowSubtitleListEvent>(_onShowSubtitleList);
    on<PlayerHideSubtitleListEvent>(_onHideSubtitleList);
    on<PlayerClickSentenceEvent>(_onClickSentence);
    on<PlayerScrollToTopEvent>(_onScrollToTop);
    on<PlayerScrollToBottomEvent>(_onScrollToBottom);
    on<PlayerScrollToPlayingSentenceEvent>(_onScrollToPlayingSentence);
    on<PlayerGoToAlbumListEvent>(_onGoToAlbumList);
    on<PlayerPositionChangeByPlayingEvent>(_onPositionChangeByPlaying);
    on<PlayerToggleVolumeEvent>(_onToggleVolume);
    on<PlayerPauseEvent>(_onPause);
    on<PlayerPlayEvent>(_onPlay);
    on<PlayerToggleLoopEvent>(_onToggleLoop);
    on<PlayerResetSpeedEvent>(_onResetSpeed);
    on<PlayerIncSpeedEvent>(_onIncSpeed);
    on<PlayerDecSpeedEvent>(_onDecSpeed);
    on<PlayerMediaSliderStartChangeEvent>(_onMediaSliderStartChange);
    on<PlayerMediaSliderChangingEvent>(_onMediaSliderChanging);
    on<PlayerMediaSliderEndChangeEvent>(_onMediaSliderEndChange);
    on<PlayerVolumeChangeEvent>(_onVolumeChange);
    on<PlayerSyncFromBackgroundAudioEvent>(_onSyncFromBackgroundAudio);
    _subscriptionList.addAll([
      EventHub.on<HubSubtitleChangeEvent>(
        (event) => add(PlayerSelectAnotherSubtitleFromListEvent(event.name)),
      ),
      EventHub.on<HubAppPauseEvent>(_onAppPause),
      EventHub.on<HubSyncBackgroundAudioToPlayerEvent>(
        (event) => add(
          PlayerSyncFromBackgroundAudioEvent(playing: event.playing, position: event.position),
        ),
      ),
    ]);
  }

  void _onAppPause(HubAppPauseEvent event) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final media = _media;
    if (media == null) return;

    //save position
    await _updateProgressPosition(state.position);

    //sync to background audio player
    final playerInfo = PlayerInfo(
      media: media,
      duration: state.duration,
      playing: state.playing,
      position: state.position,
      speed: state.speed,
      volume: state.volume,
      loopIndex: state.loopIndex,
      sentenceList: state.selectedSubtitle?.sentenceList ?? const [],
    );
    EventHub.emit(HubSyncPlayerToBackgroundAudioEvent(playerInfo));
  }

  Future<void> _updateProgressPosition(Duration position) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final metadata = await DB.loadMetadata();
    var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == _media?.id);
    if (progress != null) {
      progress = progress.copyWith(positionMs: position.inMilliseconds);
      await DB.updateProgress(progress);
    }
  }

  void _onSelectAnotherSubtitleFromList(
    PlayerSelectAnotherSubtitleFromListEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    state = state.copyWith(
      selectedSubtitleName: () => event.name,
      subtitleListVisible: false,
      subtitleState: PlayerSubtitleDataState(
        sentenceList: state.selectedSubtitle?.sentenceList ?? [],
        initialAlignment: _spot?.alignment ?? 0,
        initialIndex: _spot?.index ?? 0,
      ),
    );
    emit(state);
    EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));

    var metadata = await DB.loadMetadata();
    var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == _media?.id);
    if (progress != null) {
      progress = progress.copyWith(subtitleName: () => event.name);
      await DB.updateProgress(progress);
    }
  }

  void _onClickSentence(PlayerClickSentenceEvent event, Emitter<PlayerState> emit) async {
    /*Fix loop mode, tap sentence bug
    in loop mode, you seek from s(n)->s(n+1),
    because it beyond s(n) end, so it trigger reseek to start
    same reason you seek from s(n)->s(n-1) will works perfectly,
    so in loop mode, which sentence is loop wee need to manually maintain,
    can't rely on position listening
     */
    var dataState = state;
    if (dataState is! PlayerDataState) return;
    final sentenceIndex = dataState.selectedSubtitle?.sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == event.sentenceId,
    );
    if (sentenceIndex == null) return;
    final sentence = dataState.selectedSubtitle?.sentenceList[sentenceIndex];
    if (sentence == null) return;
    if (dataState.loopIndex != null) {
      dataState = dataState.copyWith(loopIndex: () => sentenceIndex);
    }
    EventHub.emit(HubPlayingSentenceChangeEvent(sentence.id));
    final double alignment = sentenceIndex == 0 ? 0 : 0.3;
    dataState.scroller.safeScrollTo(sentenceIndex, alignment: alignment);
    emit(dataState.copyWith(playing: true));
    await dataState.player.seekTo(sentence.start);
    await dataState.player.play();
  }

  void _onShowSubtitleList(PlayerShowSubtitleListEvent event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(subtitleListVisible: true));
  }

  void _onHideSubtitleList(PlayerHideSubtitleListEvent event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(subtitleListVisible: false));
  }

  // void _onPickLibraryFileForSubtitle() async {

  // }

  // void _onSelectSubtitle(
  //   PlayerSelectSubtitleEvent event,
  //   Emitter<PlayerState> emit,
  // ) async {
  //   final state = this.state;
  //   if (state is! PlayerDataState) return;
  //   final subtitle = state.subtitleList[event.index];
  //   if (_subtitle == subtitle) return;

  //   _prevSubtitle = null; // force reload scroller
  //   final subtitleState = PlayerSubtitleDataState(subtitle.sentenceList);

  //   // Save selection to metadata
  //   var metadata = await DB.loadMetadata();
  //   metadata = metadata.copyWith(playingSubtitleName: () => subtitle.name);
  //   await DB.updateMetadata(metadata);

  //   emit(
  //     state.copyWith(
  //       subtitleState: subtitleState,
  //       selectedSubtitleIndex: () => event.index,
  //       showSubtitleList: false, // Close list after selection
  //     ),
  //   );
  // }

  void _onScrollToTop(PlayerScrollToTopEvent event, Emitter<PlayerState> emit) {
    state.as<PlayerDataState>()?.scroller.safeScrollTo(0);
  }

  void _onScrollToBottom(PlayerScrollToBottomEvent event, Emitter<PlayerState> emit) {
    final dataState = state;
    if (dataState is! PlayerDataState) return;
    final subtitle = dataState.selectedSubtitle;
    if (subtitle == null || subtitle.sentenceList.isEmpty) return;
    dataState.scroller.safeScrollTo(subtitle.sentenceList.length - 1);
  }

  void _onScrollToPlayingSentence(
    PlayerScrollToPlayingSentenceEvent event,
    Emitter<PlayerState> emit,
  ) {
    final index = _spot?.index;
    if (index == null) return;
    state.as<PlayerDataState>()?.scroller.safeScrollTo(index, alignment: 0.3);
  }

  void _onGoToAlbumList(PlayerGoToAlbumListEvent event, Emitter<PlayerState> emit) {
    event.context.go(AppRoute.albumList);
  }

  void _onVolumeChange(PlayerVolumeChangeEvent event, Emitter<PlayerState> emit) async {
    var dataState = state;
    if (dataState is! PlayerDataState) return;
    emit(dataState.copyWith(volume: event.volume));
    await dataState.player.setVolume(event.volume);
  }

  void _onPositionChangeByPlaying(
    PlayerPositionChangeByPlayingEvent event,
    Emitter<PlayerState> emit,
  ) async {
    //Fix switch media, old listener still execute bug
    if (_media == null) return;
    //Seperate dragging and playing position change listener

    var state = this.state;
    if (state is! PlayerDataState) return;
    if (!state.playing) return;
    final positionUpdated = _updatePropertiesWithPosition(position: event.position, emit: emit);
    if (positionUpdated.mediaCompleted) {
      //audo re-play media
      state = state.copyWith(playing: true);
      emit(state);
      await state.player.seekTo(Duration.zero);
      await state.player.play();
    }
    final completedLoopSentence = positionUpdated.completedLoopSentence;
    if (completedLoopSentence != null) {
      //reseek loop sentence
      await state.player.seekTo(completedLoopSentence.start);
    }
    if (positionUpdated.sentenceChanged) {
      //handle scroll
      if (state.loopIndex == null) {
        //playing auto scroll to next sentence, not for loop mode
        state.scroller.safeScrollTo(_spot?.index, alignment: _spot?.alignment ?? 0);
      }
    }
  }

  Future<void> _onPositionChangeByDragging(Duration position, Emitter<PlayerState> emit) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    if (state.playing) {
      state = state.copyWith(playing: false);
      emit(state);
      await state.player.pause();
    }
    await state.player.seekTo(position);
    final positionUpdatedResult = _updatePropertiesWithPosition(position: position, emit: emit);
    if (state.loopIndex != null) {
      state = state.copyWith(loopIndex: () => _spot?.index);
      emit(state);
    }
    if (positionUpdatedResult.sentenceChanged) {
      //handle scroll
      final spot = _spot;
      if (spot != null) {
        state.scroller.safeJumpTo(spot.index, alignment: spot.alignment);
      }
    }
  }

  PositionUpdated _updatePropertiesWithPosition({
    required Duration position,
    required Emitter<PlayerState> emit,
  }) {
    var result = (mediaCompleted: false, completedLoopSentence: null, sentenceChanged: false);
    var state = this.state;
    if (state is! PlayerDataState) return result;

    //Fix while tap video slider, it bounce at first
    state = state.copyWith(position: position);
    emit(state);

    final mediaCompleted = position >= state.duration;

    //handle loop reseek
    final loopIndex = state.loopIndex;
    final loopSentence = loopIndex == null
        ? null
        : state.selectedSubtitle?.sentenceList.elementAtOrNull(loopIndex);
    SentenceEntity? completedLoopSentence;
    if (loopSentence != null && position > loopSentence.end) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      completedLoopSentence = loopSentence;
    }

    //handle scroll
    final sentenceChanged = _spot?.sentence.id != _prevSpot?.sentence.id;
    if (sentenceChanged) {
      EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));
    }
    _prevSpot = _spot;
    return (
      mediaCompleted: mediaCompleted,
      completedLoopSentence: completedLoopSentence,
      sentenceChanged: sentenceChanged,
    );
  }

  @override
  Future<void> close() {
    debugPrint('player bloc ${identityHashCode(this)} closed');
    for (final sub in _subscriptionList) {
      sub.cancel();
    }
    state.as<PlayerDataState>()?.player.dispose();
    return super.close();
  }

  void _onToggleVolume(PlayerToggleVolumeEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(volumeSliderVisible: !state.volumeSliderVisible));
  }

  void _onPlay(PlayerPlayEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: true));
    if (state.position >= state.duration) {
      await state.player.seekTo(Duration.zero);
    }
    await state.player.play();
  }

  void _onPause(PlayerPauseEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: false));
    await state.player.pause();
  }

  void _onToggleLoop(_, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    if (state.loopIndex == null) {
      //to loop
      emit(state.copyWith(loopIndex: () => _spot?.index));
    } else {
      emit(state.copyWith(loopIndex: () => null));
    }
  }

  void _onMediaSliderStartChange(
    PlayerMediaSliderStartChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    _mediaPlayingBeforeDrag = state.playing;
    await _onPositionChangeByDragging(event.position, emit);
  }

  void _onMediaSliderChanging(
    PlayerMediaSliderChangingEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await _onPositionChangeByDragging(event.position, emit);
  }

  void _onMediaSliderEndChange(
    PlayerMediaSliderEndChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    await _onPositionChangeByDragging(event.position, emit);
    if (event.position < event.duration && _mediaPlayingBeforeDrag) {
      emit(state.copyWith(playing: true));
      await state.player.play();
    }
  }

  void _onResetSpeed(PlayerResetSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onIncSpeed(PlayerIncSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed + _kStepPlaySpeed)
        .clamp(_kMinPlaySpeed, _kMaxPlaySpeed)
        .digits(1);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onDecSpeed(PlayerDecSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed - _kStepPlaySpeed)
        .clamp(_kMinPlaySpeed, _kMaxPlaySpeed)
        .digits(1);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onInit(PlayerInitEvent event, Emitter<PlayerState> emit) async {
    EasyLoading.show(maskType: .clear);
    //before switch media, update old media's progress position
    var state = this.state;
    if (state is PlayerDataState) {
      await _updateProgressPosition(state.position);
    }

    final metadata = await DB.loadMetadata();
    final mediaId = event.mediaId ?? metadata.playingMediaId;
    final media = mediaId == null ? null : await AssetEntity.fromId(mediaId);
    if (media == null) {
      state = await _reload(null);
    } else {
      var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == mediaId);
      final position = progress?.position ?? Duration.zero;
      state = await _reload((media: media, playing: true, position: position, loopIndex: null,
      selectedSubtitleName: progress?.subtitleName));
    }
    emit(state);
    EasyLoading.dismiss();
  }

  void _onSyncFromBackgroundAudio(
    PlayerSyncFromBackgroundAudioEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await defer(() async {
      EasyLoading.dismiss();
      
    }, () async {
      EasyLoading.show(maskType: .clear);
      var state = this.state;
      if (state is! PlayerDataState) return;
      final mediaId = _media?.id;
      if (mediaId == null) return;

      final media = await AssetEntity.fromId(mediaId);
      if (media == null) {
        state = await _reload(null);
      } else {
        state = await _reload((
            media: media,
            selectedSubtitleName: state.selectedSubtitleName,
            loopIndex: state.loopIndex,
            position: event.position,
            playing: event.playing)
        );
      }
      emit(state);
    });
  }

  Future<PlayerState> _reload(
    ({
      AssetEntity media,
      bool playing,
      int? loopIndex,
      Duration position,
      String? selectedSubtitleName,
    })?
    info,
  ) async {
    final newState = await defer<PlayerState>(
      () async {
        var metadata = await DB.loadMetadata();
        metadata = metadata.copyWith(playingMediaId: () => info?.media.id);
        await DB.updateMetadata(metadata);
        _media = info?.media;
      },
      () async {
        //Fix switch media, old listener still execute bug
        _media = null;
        if (info == null) {
          return const PlayerEmptyState();
        }
        //because of this is read and have to await, this has to be a AsyncNotifier
        final mediaFile = await info.media.file;
        if (mediaFile == null) {
          return const PlayerEmptyState();
        }
        state.as<PlayerDataState>()?.player.dispose();
        final player = VideoPlayerController.file(mediaFile);
        await player.initialize();
        player.addListener(() => add(PlayerPositionChangeByPlayingEvent(player.value.position)));
        final title = await info.media.titleAsync;
        var metadata = await DB.loadMetadata();
        var progress = metadata.mediaProgressList.firstWhereOrNull(
          (mp) => mp.mediaId == info.media.id,
        );
        final (:subtitleList, :selectedSubtitleName, :subtitleState, :subtitleListButtonVisible) =
            await _reloadSubtitle(info.media, info.selectedSubtitleName, info.position);
        progress =
            progress?.copyWith(
              mediaId: info.media.id,
              positionMs: info.position.inMilliseconds,
              subtitleName: () => selectedSubtitleName,
            ) ??
            MediaProgressEntity(
              positionMs: info.position.inMilliseconds,
              mediaId: info.media.id,
              subtitleName: selectedSubtitleName,
            );
        if (progress.id == 0) {
          metadata.mediaProgressList.add(progress);
          await DB.updateMetadata(metadata);
        }
        await player.seekTo(info.position);
        if (info.playing) {
          await player.play();
        }
        final int? loopIndex;
        if (state.as<PlayerDataState>()?.loopIndex == null) {
          loopIndex = null;
        } else {
          final sentenceList = subtitleList.firstWhereOrNull((s)=>s.name == selectedSubtitleName)
              ?.sentenceList;
          loopIndex = sentenceList?.spot(info
              .position)?.index;
        }
        return PlayerDataState(
          aspectRatio: player.value.aspectRatio,
          subtitleList: subtitleList,
          selectedSubtitleName: selectedSubtitleName,
          subtitleListVisible: false,
          subtitleListButtonVisible: subtitleListButtonVisible,
          volumeSliderVisible: false,
          loopIndex: loopIndex,
          playing: info.playing,
          subtitleState: subtitleState,
          position: info.position,
          duration: player.value.duration,
          volume: 1,
          speed: 1,
          mediaType: info.media.type,
          title: title,
          player: player,
          scroller: ItemScrollController(),
        );
      },
    );
    return newState;
  }

  Future<
    ({
      List<SubtitleEntity> subtitleList,
      String? selectedSubtitleName,
      PlayerSubtitleState subtitleState,
      bool subtitleListButtonVisible,
    })
  >
  _reloadSubtitle(AssetEntity media, String? selectedSubtitleName, Duration position) async {
    final subtitleList = await media.subtitleList;
    if (!subtitleList.any((s) => s.name == selectedSubtitleName)) {
      selectedSubtitleName = subtitleList.firstOrNull?.name;
    }
    final subtitle = subtitleList.firstWhereOrNull((s) => s.name == selectedSubtitleName);
    final spot = subtitle?.sentenceList.spot(position);
    EventHub.emit(HubPlayingSentenceChangeEvent(spot?.sentence.id));
    final PlayerSubtitleState subtitleState;
    if (spot == null || subtitle == null) {
      subtitleState = const PlayerSubtitleEmptyState();
    } else {
      subtitleState = PlayerSubtitleDataState(
        sentenceList: subtitle.sentenceList,
        initialAlignment: spot.alignment,
        initialIndex: spot.index,
      );
    }
    return (
      subtitleList: subtitleList,
      selectedSubtitleName: selectedSubtitleName,
      subtitleState: subtitleState,
      subtitleListButtonVisible: subtitleList.length > 1,
    );
  }

  @override
  SentenceCardBlocType sentenceCardBlocAtIndex(int index) {
    final sentence = state.as<PlayerDataState>()?.selectedSubtitle?.sentenceList[index];
    final playing = _spot?.index == index;
    return SentenceCardBloc(sentence)..add(SentenceCardInitEvent(playing));
  }

  @override
  PlayerSubtitleListBlocType get subtitleListBlocType {
    return PlayerSubtitleListBloc(
      state.as<PlayerDataState>()?.subtitleList ?? [],
      state.as<PlayerDataState>()?.selectedSubtitleName,
    );
  }

  //   Future<String?> _pickOneSubtitle() async {
  //     try {
  //       final subtitleExtensions = {'.srt', '.vtt'};
  //       final pickedFiles = await FilePicker.pickFiles(
  //         type: FileType.custom,
  //         allowedExtensions: [...subtitleExtensions],
  //       );
  //       final subtitlePath = pickedFiles
  //           .map((pf) => File(pf.xFile.path))
  //           .toList()
  //           .firstWhereOrNull(
  //             (f) => subtitleExtensions.contains(p.extension(f.path)),
  //           )
  //           ?.path;
  //       return subtitlePath;
  //     } catch (e) {
  //       debugPrint('Error adding subtitle: $e');
  //       return null;
  //     }
  //   }
  // }
}

extension on SpotType {
  double get alignment => index == 0 ? 0 : 0.3;
}
