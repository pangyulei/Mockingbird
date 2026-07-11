import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

class AlbumListState {
  final int count;
  const AlbumListState({required this.count});

  AlbumListState copyWith({int? count}) {
    return AlbumListState(count: count ?? this.count);
  }
}
