import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/db/entities/sentence_entity.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_event.dart';
import 'package:mockingbird/tab_player/sentence_card/sentence_card_state.dart';
import 'package:mockingbird/tool/event_hub.dart';

class SentenceCardBloc extends Bloc<SentenceCardEvent, SentenceCardState> {
  final _subList = <StreamSubscription>[];
  final SentenceEntity _sentence;
  SentenceCardBloc(this._sentence) : super(const SentenceCardState.empty()) {
    on<SentenceCardInitEvent>(_onInit);
    on<SentenceCardPlayingSentenceChangedEvent>(_onPlayingSentenceChanged);
    _subList.add(
      EventHub.on<HubPlayingSentenceChangedEvent>(
        (event) => add(
          SentenceCardPlayingSentenceChangedEvent(event.playingSentenceId),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    for (final sub in _subList) {
      sub.cancel();
    }
    return super.close();
  }

  void _onInit(SentenceCardInitEvent event, Emitter<SentenceCardState> emit) {
    emit(
      state.copyWith(
        text: _sentence.text,
        period: '${_sentence.start.desc} - ${_sentence.end.desc}',
      ),
    );
  }

  void _onPlayingSentenceChanged(
    SentenceCardPlayingSentenceChangedEvent event,
    Emitter<SentenceCardState> emit,
  ) {
    emit(state.copyWith(playing: _sentence.id == event.playingSentenceId));
  }
}

extension on Duration {
  String get desc {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
