import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

class AlbumListState {
  final List<AlbumCardState> states;
  const AlbumListState({required this.states});

  AlbumListState copyWith({List<AlbumCardState>? states}) {
    return AlbumListState(states: states ?? this.states);
  }
}
