import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_event.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaCardBloc extends MediaCardBlocType {
  final AssetEntity? _media;
  final bool _initialPlaying;
  final _subList = <StreamSubscription>[];
  MediaCardBloc(this._media, this._initialPlaying)
    : super(const MediaCardState.empty()) {
    on<MediaCardInitEvent>(_onInit);
    on<MediaCardClickEvent>(_onClick);
    on<MediaCardPlayingMediaChangeEvent>(_onPlayingMediaChange);
    _subList.addAll([
      EventHub.on<HubPlayingMediaChangedEvent>(
        (event) => add(MediaCardPlayingMediaChangeEvent(event.playingMediaId)),
      ),
    ]);
  }

  void _onPlayingMediaChange(
    MediaCardPlayingMediaChangeEvent event,
    Emitter<MediaCardState> emit,
  ) {
    emit(state.copyWith(playing: _media?.id == event.playingMediaId));
  }

  @override
  Future<void> close() {
    for (final sub in _subList) {
      sub.cancel();
    }
    return super.close();
  }

  void _onClick(MediaCardClickEvent event, Emitter<MediaCardState> emit) async {
    if (_media == null) return;
    EventHub.emit(HubPlayingMediaChangedEvent(_media.id));
    event.context.go(AppRoute.player);
  }

  void _onInit(_, Emitter<MediaCardState> emit) async {
    if (_media == null) {
      return;
    }
    final title = await _media.titleAsync;
    emit(
      MediaCardState(
        name: title,
        type: _media.type,
        playing: _initialPlaying,
        hasSubtitle: false, //TODO hassubtitle
      ),
    );
  }
}
