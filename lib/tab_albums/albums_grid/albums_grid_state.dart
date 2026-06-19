import 'package:mockingbird/model/album.dart';

class AlbumsGridState {
  final List<Album> albums;
  final bool showLoading;
  final bool isAddButtonPressed;
  final bool isSelectionMode;
  final Set<int> selectedAlbumIds;

  const AlbumsGridState({
    this.albums = const [],
    this.showLoading = true,
    this.isAddButtonPressed = false,
    this.isSelectionMode = false,
    this.selectedAlbumIds = const {},
  });

  AlbumsGridState copyWith({
    List<Album>? albums,
    bool? showLoading,
    bool? isAddButtonPressed,
    bool? isSelectionMode,
    Set<int>? selectedAlbumIds,
  }) {
    return AlbumsGridState(
      albums: albums ?? this.albums,
      showLoading: showLoading ?? this.showLoading,
      isAddButtonPressed: isAddButtonPressed ?? this.isAddButtonPressed,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedAlbumIds: selectedAlbumIds ?? this.selectedAlbumIds,
    );
  }

  bool isAlbumSelected(int playlistId) {
    return selectedAlbumIds.contains(playlistId);
  }
}
