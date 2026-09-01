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
import 'package:mockingbird/tool/shared_metadata.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

class SharedPlayerBloc {
  static final instance = PlayerBloc();
}

class PlayerBloc extends PlayerBlocType {
  bool _draggingVideoSlider = false;
  bool _videoSliderRestorePlaying = false;
  AssetEntity? _media;

  ({int index, SentenceEntity sentence})? _spot;
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
    on<PlayerPositionChangeEvent>(_onPlayingPositionChange);
    on<PlayerToggleVolumeEvent>(_onToggleVolume);
    on<PlayerPauseEvent>(_onPause);
    on<PlayerPlayEvent>(_onPlay);
    on<PlayerToggleLoopEvent>(_onToggleLoop);
    on<PlayerResetSpeedEvent>(_onResetSpeed);
    on<PlayerIncSpeedEvent>(_onIncSpeed);
    on<PlayerDecSpeedEvent>(_onDecSpeed);
    on<PlayerVideoSliderStartChangeEvent>(_onVideoSliderStartChange);
    on<PlayerVideoSliderChangingEvent>(_onVideoSliderChanging);
    on<PlayerVideoSliderEndChangeEvent>(_onVideoSliderEndChange);
    on<PlayerVolumeChangeEvent>(_onVolumeChange);
    _subscriptionList.addAll([
      EventHub.on<HubSubtitleChangeEvent>(
        (event) => add(PlayerSubtitleChangeEvent(event.index)),
      ),
      EventHub.on<HubAppInactiveEvent>(_onAppInactive),
    ]);
  }

  void _onAppInactive(HubAppInactiveEvent event) {
    final state = this.state.as<PlayerDataState>();
    final media = _media;
    final PlayerInfo? playerInfo;
    if (state == null || media == null) {
      playerInfo = null;
    } else {
      playerInfo = PlayerInfo(
        media: media,
        duration: state.duration,
        playing: state.playing,
        position: state.position,
        speed: state.speed,
        volume: state.volume,
      );
    }
    EventHub.emit(HubAppInactiveSyncPlayerEvent(playerInfo));
  }

  void _onSubtitleChange(
    PlayerSubtitleChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var dataState = state.as<PlayerDataState>();
    if (dataState == null) return;
    if (dataState.selectedSubtitleIndex == event.index) return;
    _spot = _spotSentence(dataState.position, dataState.subtitle?.sentenceList);
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
    final progress = SharedMetadata.instance
        .mediaProgressById(_media?.id)
        ?.copyWith(subtitleName: () => dataState?.subtitle?.name);
    SharedMetadata.instance.updateMediaProgress(progress);
  }

  void _onClickSentence(
    PlayerClickSentenceEvent event,
    Emitter<PlayerState> emit,
  ) async {
    /*Fix loop mode, tap sentence bug
    in loop mode, you seek from s(n)->s(n+1),
    because it beyond s(n) end, so it trigger reseek to start
    same reason you seek from s(n)->s(n-1) will works perfectly,
    so in loop mode, which sentence is loop wee need to manually maintain,
    can't rely on position listening
     */
    var dataState = state;
    if (dataState is! PlayerDataState) return;
    final sentenceIndex = dataState.subtitle?.sentenceList
        .firstIndexWhereOrNull((sen) => sen.id == event.sentenceId);
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

  void _onShowSubtitleList(
    PlayerShowSubtitleListEvent event,
    Emitter<PlayerState> emit,
  ) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(subtitleListVisible: true));
  }

  void _onHideSubtitleList(
    PlayerHideSubtitleListEvent event,
    Emitter<PlayerState> emit,
  ) {
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

  void _onScrollToBottom(
    PlayerScrollToBottomEvent event,
    Emitter<PlayerState> emit,
  ) {
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

  void _onGoToAlbumList(
    PlayerGoToAlbumListEvent event,
    Emitter<PlayerState> emit,
  ) {
    event.context.go(AppRoute.albumList);
  }

  void _onVolumeChange(
    PlayerVolumeChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var dataState = state;
    if (dataState is! PlayerDataState) return;
    emit(dataState.copyWith(volume: event.volume));
    await dataState.player.setVolume(event.volume);
  }

  void _onPlayingPositionChange(
    PlayerPositionChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    //Fix switch media, old listener still execute bug
    if (_media == null) return;
    //Seperate dragging and playing position change listener
    if (_draggingVideoSlider) return;
    var state = this.state;
    if (state is! PlayerDataState) return;

    if (event.position >= state.duration) {
      //if video end of duration, play/pause button should update
      //feature: replay if auto play to end
      state = state.copyWith(playing: true);
      emit(state);
      await state.player.seekTo(const Duration(seconds: 0));
      await state.player.play();
    }

    //handle loop reseek
    final loopIndex = state.loopIndex;
    final loopSentence = loopIndex == null
        ? null
        : state.subtitle?.sentenceList[loopIndex];
    if (loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (event.position > loopSentence.end) {
        await state.player.seekTo(loopSentence.start);
      }
    }

    final scroller = state.scroller;
    _syncCommonStatWithPosition(event.position, emit, () {
      //handle scroll
      if (loopIndex == null) {
        //playing auto scroll to next sentence, not for loop mode
        scroller.safeScrollTo(_spot?.index, alignment: _spot?.alignment ?? 0);
      }
    });
  }

  Future<void> _onDraggingPositionChange(
    Duration position,
    Emitter<PlayerState> emit,
  ) async {
    if (!_draggingVideoSlider) return;
    final state = this.state;
    if (state is! PlayerDataState) return;
    await state.player.seekTo(position);
    _syncCommonStatWithPosition(position, emit, () {
      //handle scroll
      state.scroller.safeJumpTo(_spot?.index, alignment: _spot?.alignment ?? 0);
    });
  }

  void _syncCommonStatWithPosition(
    Duration position,
    Emitter<PlayerState> emit,
    void Function() sentenceChangeCallback,
  ) {
    var state = this.state;
    if (state is! PlayerDataState) return;

    final progress = SharedMetadata.instance
        .mediaProgressById(_media?.id)
        ?.copyWith(positionMs: position.inMilliseconds);
    SharedMetadata.instance.updateMediaProgress(progress);

    //Fix while tap video slider, it bounce at first
    state = state.copyWith(position: position);
    emit(state);

    final spot = _spotSentence(position, state.subtitle?.sentenceList);
    final isSentenceChanged = _spot?.sentence.id != spot?.sentence.id;
    _spot = spot;
    if (isSentenceChanged) {
      EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));
      sentenceChangeCallback();
    }
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

  void _onToggleVolume(
    PlayerToggleVolumeEvent event,
    Emitter<PlayerState> emit,
  ) async {
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
      final spot = _spotSentence(state.position, state.subtitle?.sentenceList);
      emit(state.copyWith(loopIndex: () => spot?.index));
    } else {
      emit(state.copyWith(loopIndex: () => null));
    }
  }

  void _onVideoSliderStartChange(
    PlayerVideoSliderStartChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    _draggingVideoSlider = true;
    _videoSliderRestorePlaying = state.playing;
    emit(state.copyWith(playing: false));
    await state.player.pause();
    await _onDraggingPositionChange(event.position, emit);
  }

  void _onVideoSliderChanging(
    PlayerVideoSliderChangingEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await _onDraggingPositionChange(event.position, emit);
  }

  void _onVideoSliderEndChange(
    PlayerVideoSliderEndChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await defer(
      () async {
        _draggingVideoSlider = false;
      },
      () async {
        var state = this.state;
        if (state is! PlayerDataState) return state;
        // seek to sentence start
        final Duration targetPosition;
        if (state.loopIndex != null) {
          final spot = _spotSentence(
            event.position,
            state.subtitle?.sentenceList,
          );
          if (spot == null) {
            state = state.copyWith(loopIndex: () => null);
            targetPosition = event.position;
          } else {
            state = state.copyWith(loopIndex: () => spot.index);
            targetPosition = spot.sentence.start;
          }
        } else {
          targetPosition = event.position;
        }
        await _onDraggingPositionChange(targetPosition, emit);
        if (_videoSliderRestorePlaying && event.position < event.duration) {
          state = state.copyWith(playing: true);
          await state.player.play();
        }
        emit(state);
      },
    );
  }

  ({int index, SentenceEntity sentence})? _spotSentence(
    Duration position,
    List<SentenceEntity>? sentenceList,
  ) {
    sentenceList ??= [];
    for (int i = 0; i < sentenceList.length; i++) {
      SentenceEntity? prev = i == 0 ? null : sentenceList[i - 1];
      SentenceEntity? next = sentenceList.elementAtOrNull(i + 1);
      SentenceEntity sentence = sentenceList[i];
      if (sentence.playing(prev, next, position)) {
        return (index: i, sentence: sentence);
      }
    }
    return null;
  }

  void _onResetSpeed(
    PlayerResetSpeedEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onIncSpeed(PlayerIncSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onDecSpeed(PlayerDecSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
    await state.player.setPlaybackSpeed(nextSpeed);
  }

  void _onInit(PlayerInitEvent event, Emitter<PlayerState> emit) async {
    //Fix switch media, old listener still execute bug
    _media = null;
    EasyLoading.show(maskType: .clear);
    final mediaId = event.mediaId ?? SharedMetadata.instance.playingMediaId;
    final media = mediaId == null ? null : await AssetEntity.fromId(mediaId);
    final state = await _reload(media);
    emit(state);
    await state.as<PlayerDataState>()?.player.play();
    SharedMetadata.instance = SharedMetadata.instance.copyWith(
      playingMediaId: () => mediaId,
    );
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
    player.addListener(
      () => add(PlayerPositionChangeEvent(player.value.position)),
    );
    final title = await media.titleAsync;
    final subtitleList = await media.subtitleList;
    final int? selectedSubtitleIndex;
    final Duration position;
    var progress = SharedMetadata.instance.mediaProgressById(media.id);
    if (progress == null) {
      progress = MediaProgressEntity(mediaId: media.id, positionMs: 0);
      selectedSubtitleIndex = subtitleList.isEmpty ? null : 0;
      position = const Duration(seconds: 0);
    } else {
      final selectedSubtitleName = progress.subtitleName;
      selectedSubtitleIndex =
          subtitleList.firstIndexWhereOrNull(
            (sub) => sub.name == selectedSubtitleName,
          ) ??
          (subtitleList.isEmpty ? null : 0);
      position = progress.position;
    }
    await player.seekTo(position);
    final subtitle = selectedSubtitleIndex == null
        ? null
        : subtitleList.elementAtOrNull(selectedSubtitleIndex);
    progress = progress.copyWith(subtitleName: () => subtitle?.name);
    SharedMetadata.instance.updateMediaProgress(progress);
    final spot = _spotSentence(position, subtitle?.sentenceList);
    _spot = spot;
    EventHub.emit(HubPlayingSentenceChangeEvent(spot?.sentence.id));
    final PlayerSubtitleState subtitleState;
    if (spot == null || subtitle == null) {
      subtitleState = const PlayerSubtitleEmptyState();
    } else {
      subtitleState = PlayerSubtitleDataState(
        subtitle.sentenceList,
        spot.alignment,
        spot.index,
      );
    }
    return PlayerDataState(
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

extension on SentenceEntity {
  bool playing(SentenceEntity? prev, SentenceEntity? next, Duration position) {
    final start = prev == null ? const Duration(seconds: 0) : this.start;
    if (next == null) {
      return start <= position;
    } else {
      return start <= position && position < next.start;
    }
  }
}

extension on ({int index, SentenceEntity sentence}) {
  double get alignment => index == 0 ? 0 : 0.3;
}
