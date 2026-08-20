import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:defer/defer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/tab_player/player/player.dart';
import 'package:mockingbird/tab_player/player/player_event.dart';
import 'package:mockingbird/tab_player/player/player_state.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:mockingbird/tool/subtitle_parser.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const double _kMaxPlaySpeed = 3.0;
const double _kMinPlaySpeed = 0.25;
const double _kStepPlaySpeed = 0.25;

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final ItemScrollController _scrollController;
  bool _isDraggingVideoSlider = false;
  bool _isPlayingBeforeDraged = false;
  String? _mediaId;
  final _subList = <StreamSubscription>[];

  PlayerBloc(this._scrollController) : super(const PlayerInitState()) {
    on<PlayerInitEvent>(_onInit);
    on<PlayerPositionChangeEvent>(_onMediaPositionChange);
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
    _subList.addAll([
      SharedPlayer.player.stream.position.listen(
        (position) => add(PlayerPositionChangeEvent(position)),
      ),
      EventHub.on<HubPlayingMediaChangedEvent>(
        (event) => add(PlayerInitEvent(event.playingMediaId)),
      ),
    ]);
  }

  void _onMediaPositionChange(
    PlayerPositionChangeEvent event,
    Emitter<PlayerState> emit,
  ) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(position: event.position));
  }

  @override
  Future<void> close() {
    for (final sub in _subList) {
      sub.cancel();
    }
    return super.close();
  }

  void _onToggleVolume(
    PlayerToggleVolumeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(showVolumeSlider: !state.showVolumeSlider));
  }

  void _onPlay(PlayerPlayEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: true));
    if (state.position >= state.duration) {
      await SharedPlayer.player.seek(const Duration(seconds: 0));
    }
    await SharedPlayer.player.play();
  }

  void _onPause(PlayerPauseEvent event, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    emit(state.copyWith(playing: false));
    await SharedPlayer.player.pause();
  }

  void _onToggleLoop(_, Emitter<PlayerState> emit) async {
    final state = this.state;
    if (state is! PlayerDataState) return;
    if (state.loopIndex == null) {
      //to loop
      emit(
        state.copyWith(
          loopIndex: () => _spotSentenceByPosition(state.position)?.spotIndex,
        ),
      );
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
    _isDraggingVideoSlider = true;
    _isPlayingBeforeDraged = state.playing;
    emit(state.copyWith(playing: false));
    await SharedPlayer.player.pause();
    await SharedPlayer.player.seek(event.position);
  }

  void _onVideoSliderChanging(
    PlayerVideoSliderChangingEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await SharedPlayer.player.seek(event.position);
  }

  void _onVideoSliderEndChange(
    PlayerVideoSliderEndChangeEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final newState = await defer<PlayerState>(
      () async {
        _isDraggingVideoSlider = false;
      },
      () async {
        var state = this.state;
        if (state is! PlayerDataState) return state;
        // seek to sentence start
        final Duration targetPosition;
        if (state.loopIndex != null) {
          final spot = _spotSentenceByPosition(event.position);
          if (spot == null) {
            state = state.copyWith(loopIndex: () => null);
            targetPosition = event.position;
          } else {
            final (:spotIndex, :spotSentence) = spot;
            state = state.copyWith(loopIndex: () => spotIndex);
            targetPosition = spotSentence.start;
          }
        } else {
          targetPosition = event.position;
        }
        await SharedPlayer.player.seek(targetPosition);
        if (_isPlayingBeforeDraged && event.position < event.duration) {
          state = state.copyWith(playing: true);
          await SharedPlayer.player.play();
        }
        return state;
      },
    );
    emit(newState);
  }

  ({int spotIndex, SentenceEntity spotSentence})? _spotSentenceByPosition(
    Duration position,
  ) {
    final sentenceList = state
        .as<PlayerDataState>()
        ?.subtitle
        .as<PlayerSubtitleDataState>()
        ?.sentenceList;
    if (sentenceList == null) return null;
    for (int i = 0; i < sentenceList.length; i++) {
      SentenceEntity? prev = i == 0 ? null : sentenceList[i - 1];
      SentenceEntity? next = sentenceList.elementAtOrNull(i + 1);
      SentenceEntity sentence = sentenceList[i];
      if (sentence.playing(prev, next, position)) {
        return (spotIndex: i, spotSentence: sentence);
      }
    }
    return null;
  }

  void _onResetSpeed(PlayerResetSpeedEvent event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final nextSpeed = (1.0).clamp(_kMinPlaySpeed, _kMaxPlaySpeed);
    emit(state.copyWith(speed: nextSpeed));
  }

  void _onIncSpeed(PlayerIncSpeedEvent event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed + _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
  }

  void _onDecSpeed(PlayerDecSpeedEvent event, Emitter<PlayerState> emit) {
    final state = this.state;
    if (state is! PlayerDataState) return;
    final double nextSpeed = (state.speed - _kStepPlaySpeed).clamp(
      _kMinPlaySpeed,
      _kMaxPlaySpeed,
    );
    emit(state.copyWith(speed: nextSpeed));
  }

  void _onInit(PlayerInitEvent event, Emitter<PlayerState> emit) async {
    _mediaId = event.mediaId;
    emit(await _reload(event.mediaId));
  }

  Future<PlayerState> _reload(String? mediaId) async {
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
    final player = SharedPlayer.player;
    await player.open(Media(mediaFile.path));
    final title = await media.titleAsync;
    final subtitleList = await _loadSubtitleList(mediaFile);
    final metadata = await DB.loadMetadata();
    final subtitle = subtitleList.firstWhereOrNull(
      (s) => s.name == metadata.playingSubtitleName,
    ) ?? subtitleList.firstOrNull;
    final subtitleState = subtitle == null
        ? const PlayerSubtitleEmptyState()
        : PlayerSubtitleDataState(sentenceList: subtitle.sentenceList);
    return PlayerDataState(
      showVolumeSlider: false,
      loopIndex: null,
      playing: true,
      subtitle: subtitleState,
      position: const Duration(seconds: 0),
      duration: player.state.duration,
      volume: 100,
      speed: 1,
      mediaType: media.type,
      title: title,
    );
  }

  Future<List<SubtitleEntity>> _loadSubtitleList(File mediaFile) async {
    //找到同目录下的名称对应上的srt或vtt字幕文件
    final subtitleList = <SubtitleEntity>[];
    await for (final subFile in mediaFile.parent.list()) {
      if (subFile is! File) continue;
      final extension = p.extension(subFile.path); //带.
      if (!{'.srt', '.vtt'}.contains(extension)) continue;
      final subtitleName = p.basenameWithoutExtension(subFile.path);
      final mediaName = p.basenameWithoutExtension(mediaFile.path);
      final matched = subtitleName.toLowerCase().contains(
        mediaName.toLowerCase(),
      );
      if (matched) {
        final subtitleEntity = await SubtitleParser.parseFile(subFile);
        if (subtitleEntity != null) {
          subtitleList.add(subtitleEntity);
        }
      }
    }
    return subtitleList;
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
