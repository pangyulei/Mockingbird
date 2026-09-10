import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/mobile/db/entities/subtitle_entity.dart';
import 'package:mockingbird/mobile/tab_player/player_subtitle_list/player_subtitle_list_event.dart';
import 'package:mockingbird/mobile/tab_player/player_subtitle_list/player_subtitle_list_state.dart';
import 'package:mockingbird/mobile/tab_player/player_subtitle_list/player_subtitle_list_ui.dart';

class PlayerSubtitleListBloc extends PlayerSubtitleListBlocType {
  final List<SubtitleEntity> _subtitleList;
  final String? _selectedSubtitleName;

  PlayerSubtitleListBloc(this._subtitleList, this._selectedSubtitleName)
    : super(PlayerSubtitleListState(_selectedSubtitleName, _subtitleList)) {
    on<PlayerSubtitleListSelectNameEvent>(_onSelectName);
  }

  void _onSelectName(
    PlayerSubtitleListSelectNameEvent event,
    Emitter<PlayerSubtitleListState> emit,
  ) {
    if (_selectedSubtitleName != event.name) {
      emit(PlayerSubtitleListState(event.name, _subtitleList));
    }
    Navigator.pop(event.context);
  }
}
