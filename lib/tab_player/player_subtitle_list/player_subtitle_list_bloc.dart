import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/db/entities/subtitle_entity.dart';
import 'package:mockingbird/tab_player/player_subtitle_list/player_subtitle_list_event.dart';
import 'package:mockingbird/tab_player/player_subtitle_list/player_subtitle_list_state.dart';
import 'package:mockingbird/tab_player/player_subtitle_list/player_subtitle_list_ui.dart';

class PlayerSubtitleListBloc extends PlayerSubtitleListBlocType {
  final List<SubtitleEntity> _subtitleList;
  PlayerSubtitleListBloc(this._subtitleList, int? selectedIndex)
    : super(PlayerSubtitleListState(selectedIndex, _subtitleList)) {
    // on<PlayerSubtitleListInitEvent>(_onInit);
    on<PlayerSubtitleListSelectIndexEvent>(_onSelectIndex);
  }

  void _onSelectIndex(
    PlayerSubtitleListSelectIndexEvent event,
    Emitter<PlayerSubtitleListState> emit,
  ) {
    emit(PlayerSubtitleListState(event.index, _subtitleList));
    Navigator.pop(event.context);
  }

}
