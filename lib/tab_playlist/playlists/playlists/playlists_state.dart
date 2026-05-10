import 'package:mockingbird/models/playlist.dart';

class PlaylistsState {
  final List<Playlist> playlists;
  final bool isLoadingAll;
  final bool isAddButtonPressed;
  final bool isSelectionMode;
  final Set<int> selectedPlaylistIds;
  
  const PlaylistsState({
    this.playlists = const [],
    this.isLoadingAll = true,
    this.isAddButtonPressed = false,
    this.isSelectionMode = false,
    this.selectedPlaylistIds = const {},
  });

  PlaylistsState copyWith({
    List<Playlist>? playlists,
    bool? showLoading,
    bool? isAddButtonPressed,
    bool? isSelectionMode,
    Set<int>? selectedPlaylistIds,
  }) {
    return PlaylistsState(
      playlists: playlists != null ? [...playlists] : [...this.playlists],
      isLoadingAll: showLoading ?? isLoadingAll,
      isAddButtonPressed: isAddButtonPressed ?? this.isAddButtonPressed,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedPlaylistIds: selectedPlaylistIds ?? {...this.selectedPlaylistIds},
    );
  }
  
  bool isPlaylistSelected(int playlistId) {
    return selectedPlaylistIds.contains(playlistId);
  }
}
