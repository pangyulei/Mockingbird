import 'package:mockingbird/model/album.dart';

class AlbumCardState {
  final bool isPressed;
  final Album album; //TODO transform to primitive datas
  const AlbumCardState({
    required this.album,
    this.isPressed = false
  });

  AlbumCardState copyWith({
    Album? album,
    bool? isPressed}) {
    return AlbumCardState(
      album: album ?? this.album,
      isPressed: isPressed ?? this.isPressed
    );
  }
}
