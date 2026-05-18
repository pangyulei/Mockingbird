import 'package:mockingbird/models/playlist.dart';

class PlaylistsGridState {
  final List<Playlist> playlists;
  final bool showLoading;
  final bool isAddButtonPressed;
  final bool isSelectionMode;
  final Set<int> selectedPlaylistIds;

  const PlaylistsGridState({
    this.playlists = const [],
    this.showLoading = true,
    this.isAddButtonPressed = false,
    this.isSelectionMode = false,
    this.selectedPlaylistIds = const {},
  });

  PlaylistsGridState copyWith({
    Iterable<Playlist>? playlists,
    bool? showLoading,
    bool? isAddButtonPressed,
    bool? isSelectionMode,
    Set<int>? selectedPlaylistIds,
  }) {
    return PlaylistsGridState(
      playlists: (playlists ?? this.playlists)
          .map((e) => e.copyWith())
          .toList(),
      showLoading: showLoading ?? this.showLoading,
      isAddButtonPressed: isAddButtonPressed ?? this.isAddButtonPressed,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedPlaylistIds: selectedPlaylistIds ?? {...this.selectedPlaylistIds},
    );
  }

  bool isPlaylistSelected(int playlistId) {
    return selectedPlaylistIds.contains(playlistId);
  }
}
