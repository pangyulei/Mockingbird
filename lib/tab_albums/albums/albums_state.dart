import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

class AlbumsState {
  final List<AlbumCardState> states;
  const AlbumsState({required this.states});

  AlbumsState copyWith({List<AlbumCardState>? states}) {
    return AlbumsState(
      states: states ?? this.states,
    );
  }
}
