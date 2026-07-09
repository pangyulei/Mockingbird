import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

class AlbumsState {
  final bool isLoading;
  final List<AlbumCardState> states;
  const AlbumsState({required this.isLoading, required this.states});

  AlbumsState copyWith({bool? isLoading, List<AlbumCardState>? states}) {
    return AlbumsState(
      isLoading: isLoading ?? this.isLoading,
      states: states ?? this.states,
    );
  }
}
