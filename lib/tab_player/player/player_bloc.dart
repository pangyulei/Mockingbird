import 'dart:async';

import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db.dart';
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

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

class SharedPlayerBloc {
  static final instance = PlayerBloc();
}

class PlayerBloc extends PlayerBlocType {
  VideoPlayerController? _player;
  final _scroller = ItemScrollController();
  bool _draggingVideoSlider = false;
  bool _videoSliderRestorePlaying = false;
  String? _mediaId;

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
    on<PlayerPositionChangeEvent>(_onPositionChange);
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
      EventHub.on<HubAppPauseEvent>(_onAppPause),
    ]);
  }

  void _onAppPause(HubAppPauseEvent event) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final metadata = await DB.loadMetadata();
    await DB.updateMetadata(
      metadata.copyWith(
        playingSubtitleName: () => state.subtitle?.name,
        playingMediaId: () => _mediaId,
        playingPositionMs: state.position.inMilliseconds,
      ),
    );
  }

  void _onSubtitleChange(
    PlayerSubtitleChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    if (state.selectedSubtitleIndex == event.index) return;
    _spot = _spotSentence(state.position, state.subtitle?.sentenceList);
    emit(
      state.copyWith(
        selectedSubtitleIndex: () => event.index,
        subtitleListVisible: false,
        subtitleState: PlayerSubtitleDataState(
          state.subtitle?.sentenceList ?? [],
          0.3,
          _spot?.index ?? 0,
        ),
      ),
    );
    EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));
  }

  void _onClickSentence(
    PlayerClickSentenceEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    final sentenceIndex = state.subtitle?.sentenceList.firstIndexWhereOrNull(
      (sen) => sen.id == event.sentenceId,
    );
    if (sentenceIndex == null) return;
    /*Fix loop mode, tap sentence bug
    in loop mode, you seek from s(n)->s(n+1),
    because it beyond s(n) end, so it trigger reseek to start
    same reason you seek from s(n)->s(n-1) will works perfectly,
    so in loop mode, which sentence is loop wee need to manually maintain,
    can't rely on position listening
     */
    final sentence = state.subtitle?.sentenceList[sentenceIndex];
    if (sentence == null) return;
    if (state.loopIndex != null) {
      state = state.copyWith(loopIndex: () => sentenceIndex);
    }
    _scroller.safeScrollTo(sentenceIndex, alignment: 0.3);
    emit(state.copyWith(playing: true));
    await _player?.seekTo(sentence.start);
    await _player?.play();
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
    _scroller.safeScrollTo(0);
  }

  void _onScrollToBottom(
    PlayerScrollToBottomEvent event,
    Emitter<PlayerState> emit,
  ) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final subtitle = state.subtitle;
    if (subtitle == null || subtitle.sentenceList.isEmpty) return;
    _scroller.safeScrollTo(subtitle.sentenceList.length - 1);
  }

  void _onScrollToPlayingSentence(
    PlayerScrollToPlayingSentenceEvent event,
    Emitter<PlayerState> emit,
  ) {
    final index = _spot?.index;
    if (index == null) return;
    _scroller.safeScrollTo(index, alignment: 0.3);
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
    var state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(volume: event.volume));
    await _player?.setVolume(event.volume);
  }

  void _onPositionChange(
    PlayerPositionChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    var state = this.state;
    if (state is! PlayerDataState) return;
    final player = _player;
    if (player == null) return;
    state = state.copyWith(position: event.position);
    emit(state);
    if (event.position >= player.value.duration) {
      //if video end of duration, play/pause button should update
      //feature: replay if auto play to end
      state = state.copyWith(playing: true);
      emit(state);
      await player.seekTo(const Duration(seconds: 0));
      await player.play();
    }
    //handle loop reseek
    final loopIndex = state.loopIndex;
    final loopSentence = loopIndex == null
        ? null
        : state.subtitle?.sentenceList[loopIndex];
    if (!_draggingVideoSlider && loopSentence != null) {
      //if repeat one is turn on, while sentence finished, seek to beginning
      // debugPrint('position changing loop $sentence');
      if (event.position > loopSentence.end) {
        await player.seekTo(loopSentence.start);
      }
    }
    //handle scroll
    final spot = _spotSentence(event.position, state.subtitle?.sentenceList);
    final isSentenceChanged = _spot?.index != spot?.index;
    _spot = spot;
    if (isSentenceChanged) {
      EventHub.emit(HubPlayingSentenceChangeEvent(_spot?.sentence.id));
      if (_draggingVideoSlider) {
        _scroller.safeJumpTo(_spot?.index, alignment: 0.3);
      } else if (loopIndex == null) {
        //playing auto scroll to next sentence, not for loop mode
        _scroller.safeScrollTo(_spot?.index, alignment: 0.3);
      }
    }
  }

  @override
  Future<void> close() {
    debugPrint('player bloc ${identityHashCode(this)} closed');
    for (final sub in _subscriptionList) {
      sub.cancel();
    }
    _player?.dispose();
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
      await _player?.seekTo(const Duration(seconds: 0));
    }
    await _player?.play();
  }

  void _onPause(PlayerPauseEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: false));
    await _player?.pause();
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
    await _player?.pause();
    await _player?.seekTo(event.position);
  }

  void _onVideoSliderChanging(
    PlayerVideoSliderChangingEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await _player?.seekTo(event.position);
  }

  void _onVideoSliderEndChange(
    PlayerVideoSliderEndChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final newState = await defer<PlayerState>(
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
        await _player?.seekTo(targetPosition);
        if (_videoSliderRestorePlaying && event.position < event.duration) {
          state = state.copyWith(playing: true);
          await _player?.play();
        }
        return state;
      },
    );
    emit(newState);
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
    await _player?.setPlaybackSpeed(nextSpeed);
  }

  void _onIncSpeed(PlayerIncSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
    await _player?.setPlaybackSpeed(nextSpeed);
  }

  void _onDecSpeed(PlayerDecSpeedEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
    await _player?.setPlaybackSpeed(nextSpeed);
  }

  void _onInit(PlayerInitEvent event, Emitter<PlayerState> emit) async {
    debugPrint('player bloc ${identityHashCode(this)} on_init');
    EasyLoading.show(maskType: .clear);
    final mediaId = event.mediaId ?? (await DB.loadMetadata()).playingMediaId;
    emit(await _reload(mediaId));
    EasyLoading.dismiss();
  }

  // void _onPlayMedia(
  //   PlayerPlayMediaEvent event,
  //   Emitter<PlayerState> emit,
  // ) async {
  //   debugPrint('player bloc on play media ${event.mediaId}');
  //   EasyLoading.show(maskType: .clear);
  //   emit(await _reload(event.mediaId));
  //   EasyLoading.dismiss();
  // }

  Future<PlayerState> _reload(String? mediaId) async {
    _mediaId = mediaId;
    var metadata = await DB.loadMetadata();
    debugPrint('player bloc ${identityHashCode(this)} reloading $mediaId');
    if (mediaId == null) {
      return const PlayerEmptyState();
    }
    final media = await AssetEntity.fromId(mediaId);
    if (media == null) {
      return const PlayerEmptyState();
    }
    //because of this is read and have to await, this has to be a AsyncNotifier
    final mediaFile = await media.file;
    if (mediaFile == null) {
      return const PlayerEmptyState();
    }
    _player?.dispose();
    final player = VideoPlayerController.file(mediaFile);
    _player = player;
    await player.initialize();
    player.addListener(
      () => add(PlayerPositionChangeEvent(player.value.position)),
    );
    final title = await media.titleAsync;
    final subtitleList = await media.subtitleList;
    final int? selectedSubtitleIndex;
    final Duration position;
    if (mediaId == metadata.playingMediaId) {
      selectedSubtitleIndex =
          subtitleList.firstIndexWhereOrNull(
            (sub) => sub.name == metadata.playingSubtitleName,
          ) ??
          (subtitleList.isEmpty ? null : 0);
      position = metadata.playingPosition;
    } else {
      selectedSubtitleIndex = subtitleList.isEmpty ? null : 0;
      position = const Duration(seconds: 0);
    }
    final subtitle = selectedSubtitleIndex == null
        ? null
        : subtitleList.elementAtOrNull(selectedSubtitleIndex);
    final spot = _spotSentence(position, subtitle?.sentenceList);
    _spot = spot;
    final PlayerSubtitleState subtitleState;
    if (spot == null || subtitle == null) {
      subtitleState = const PlayerSubtitleEmptyState();
    } else {
      subtitleState = PlayerSubtitleDataState(
        subtitle.sentenceList,
        0.3,
        spot.index,
      );
    }
    debugPrint('player bloc ${identityHashCode(this)} reloaded $mediaId');
    await player.seekTo(position);
    await player.play();
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
      scroller: _scroller,
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
