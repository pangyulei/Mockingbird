import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/entities/media_progress_entity.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
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
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

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
    final sentenceList = state.subtitle?.sentenceList;
    final position = state.position;
    return sentenceList?.spot(position);
  }

  SpotType? _prevSpot;

  final _subscriptionList = <StreamSubscription>[];

  PlayerBloc() : super(const PlayerInitState()) {
    debugPrint('player bloc ${identityHashCode(this)} created');
    on<PlayerInitEvent>(_onInit);
    on<PlayerSubtitleChangeEvent>(_onSubtitleChange);
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
      EventHub.on<HubSubtitleChangeEvent>((event) => add(PlayerSubtitleChangeEvent(event.index))),
      EventHub.on<HubAppPauseEvent>(_onAppPause),
      EventHub.on<HubSyncBackgroundAudioToPlayerEvent>(
        (event) => add(
          PlayerSyncFromBackgroundAudioEvent(
            loopIndex: event.loopIndex,
            playing: event.playing,
            position: event.position,
          ),
        ),
      ),
    ]);
  }

  void _onSyncFromBackgroundAudio(
    PlayerSyncFromBackgroundAudioEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    final player = state.player;
    state = state.copyWith(playing: false);
    emit(state);
    await player.pause();

    await _onPositionChangeByDragging(event.position, emit);

    final playing = event.playing;
    state = state.copyWith(playing: playing, loopIndex: () => event.loopIndex);
    emit(state);
    if (playing) {
      await player.play();
    } else {
      await player.pause();
    }
  }

  void _onAppPause(HubAppPauseEvent event) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final media = _media;
    if (media == null) return;

    //save position
    await _updateProgressPosition();

    //sync to background audio player
    final playerInfo = PlayerInfo(
      media: media,
      duration: state.duration,
      playing: state.playing,
      position: state.position,
      speed: state.speed,
      volume: state.volume,
      loopIndex: state.loopIndex,
      sentenceList: state.subtitle?.sentenceList ?? const [],
    );
    EventHub.emit(HubSyncPlayerToBackgroundAudioEvent(playerInfo));
  }

  Future<void> _updateProgressPosition() async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final metadata = await DB.loadMetadata();
    var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == _media?.id);
    if (progress != null) {
      progress = progress.copyWith(positionMs: state.position.inMilliseconds);
      await DB.updateProgress(progress);
    }
  }

  void _onSubtitleChange(PlayerSubtitleChangeEvent event, Emitter<PlayerState> emit) async {
    var dataState = state.as<PlayerDataState>();
    if (dataState == null) return;
    if (dataState.selectedSubtitleIndex == event.index) return;

    dataState = dataState.copyWith(
      selectedSubtitleIndex: () => event.index,
      subtitleListVisible: false,
      subtitleState: PlayerSubtitleDataState(
        dataState.subtitle?.sentenceList ?? [],
        _spot?.alignment ?? 0,
        _spot?.index ?? 0,
      ),
    );
    emit(dataState);
    EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));

    var metadata = await DB.loadMetadata();
    var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == _media?.id);
    if (progress != null) {
      progress = progress.copyWith(subtitleName: () => dataState?.subtitle?.name);
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
    final sentenceIndex = dataState.subtitle?.sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == event.sentenceId,
    );
    if (sentenceIndex == null) return;
    final sentence = dataState.subtitle?.sentenceList[sentenceIndex];
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
    final subtitle = dataState.subtitle;
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
      await state.player.seekTo(const Duration(seconds: 0));
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
    final player = state.as<PlayerDataState>()?.player;
    await player?.seekTo(position);
    final positionUpdatedResult = _updatePropertiesWithPosition(position: position, emit: emit);
    if (state.as<PlayerDataState>()?.loopIndex != null) {
      emit(state.as<PlayerDataState>()?.copyWith(loopIndex: () => _spot?.index) ?? state);
    }
    if (positionUpdatedResult.sentenceChanged) {
      //handle scroll
      final spot = _spot;
      if (spot != null) {
        state.as<PlayerDataState>()?.scroller.safeJumpTo(spot.index, alignment: spot.alignment);
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
        : state.subtitle?.sentenceList.elementAtOrNull(loopIndex);
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
      await state.player.seekTo(const Duration(seconds: 0));
    }
    await state.player.play();
  }

  void _onPause(PlayerPauseEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: false));
    await state.player.pause();
  }

  void _onToggleLoop(_, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    if (state.loopIndex == null) {
      //to loop
      final spot = state.subtitle?.sentenceList.spot(state.position);
      emit(state.copyWith(loopIndex: () => spot?.index));
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
    emit(state.copyWith(playing: false));
    await state.player.pause();
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
    final double nextSpeed = (state.speed + _kStepPlaySpeed).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onDecSpeed(PlayerDecSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed - _kStepPlaySpeed).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onInit(PlayerInitEvent event, Emitter<PlayerState> emit) async {
    //before switch media, update old media's progress position
    await _updateProgressPosition();

    //Fix switch media, old listener still execute bug
    _media = null;
    EasyLoading.show(maskType: .clear);
    final String? mediaId;
    var metadata = await DB.loadMetadata();
    if (event.mediaId == null) {
      mediaId = metadata.playingMediaId;
    } else {
      mediaId = event.mediaId;
      metadata = metadata.copyWith(playingMediaId: () => event.mediaId);
      await DB.updateMetadata(metadata);
    }
    final media = mediaId == null ? null : await AssetEntity.fromId(mediaId);
    final state = await _reload(media);
    emit(state);
    await state.as<PlayerDataState>()?.player.play();
    EasyLoading.dismiss();
    _media = media;
  }

  Future<PlayerState> _reload(AssetEntity? media) async {
    if (media == null) {
      return const PlayerEmptyState();
    }
    //because of this is read and have to await, this has to be a AsyncNotifier
    final mediaFile = await media.file;
    if (mediaFile == null) {
      return const PlayerEmptyState();
    }
    state.as<PlayerDataState>()?.player.dispose();
    final player = VideoPlayerController.file(mediaFile);
    await player.initialize();
    player.addListener(() => add(PlayerPositionChangeByPlayingEvent(player.value.position)));
    final title = await media.titleAsync;
    final subtitleList = await media.subtitleList;
    final int? selectedSubtitleIndex;
    final Duration position;
    var metadata = await DB.loadMetadata();
    var progress = metadata.mediaProgressList.firstWhereOrNull((mp) => mp.mediaId == media.id);
    if (progress == null) {
      selectedSubtitleIndex = subtitleList.isEmpty ? null : 0;
      final subtitleName = selectedSubtitleIndex == null
          ? null
          : subtitleList[selectedSubtitleIndex].name;
      position = const Duration(seconds: 0);
      progress = MediaProgressEntity(mediaId: media.id, positionMs: 0, subtitleName: subtitleName);
      metadata.mediaProgressList.add(progress);
      await DB.updateMetadata(metadata);
    } else {
      final selectedSubtitleName = progress.subtitleName;
      selectedSubtitleIndex =
          subtitleList.firstIndexWhereOrNull((sub) => sub.name == selectedSubtitleName) ??
          (subtitleList.isEmpty ? null : 0);
      position = progress.position;
    }
    await player.seekTo(position);
    final subtitle = selectedSubtitleIndex == null
        ? null
        : subtitleList.elementAtOrNull(selectedSubtitleIndex);
    final spot = subtitle?.sentenceList.spot(position);
    EventHub.emit(HubPlayingSentenceChangeEvent(spot?.sentence.id));
    final PlayerSubtitleState subtitleState;
    if (spot == null || subtitle == null) {
      subtitleState = const PlayerSubtitleEmptyState();
    } else {
      subtitleState = PlayerSubtitleDataState(subtitle.sentenceList, spot.alignment, spot.index);
    }
    return PlayerDataState(
      aspectRatio: player.value.aspectRatio,
      subtitleList: subtitleList,
      selectedSubtitleIndex: selectedSubtitleIndex,
      subtitleListVisible: false,
      subtitleListButtonVisible: subtitleList.length > 1,
      volumeSliderVisible: false,
      loopIndex: null,
      playing: true,
      subtitleState: subtitleState,
      position: position,
      duration: player.value.duration,
      volume: 100,
      speed: 1,
      mediaType: media.type,
      title: title,
      player: player,
      scroller: ItemScrollController(),
    );
  }

  @override
  SentenceCardBlocType sentenceCardBlocAtIndex(int index) {
    final sentence = state.as<PlayerDataState>()?.subtitle?.sentenceList[index];
    final playing = _spot?.index == index;
    return SentenceCardBloc(sentence)..add(SentenceCardInitEvent(playing));
  }

  @override
  PlayerSubtitleListBlocType get subtitleListBlocType {
    return PlayerSubtitleListBloc(
      state.as<PlayerDataState>()?.subtitleList ?? [],
      state.as<PlayerDataState>()?.selectedSubtitleIndex,
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
