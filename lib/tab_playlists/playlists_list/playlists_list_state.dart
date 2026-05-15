import 'package:mockingbird/models/playlist.dart';

class PlaylistsListState {
  final List<Playlist> playlists;
  final bool showLoading;
  final bool isAddButtonPressed;
  final bool isSelectionMode;
  final Set<int> selectedPlaylistIds;

  const PlaylistsListState({
    this.playlists = const [],
    this.showLoading = true,
    this.isAddButtonPressed = false,
    this.isSelectionMode = false,
    this.selectedPlaylistIds = const {},
  });

  PlaylistsListState copyWith({
    Iterable<Playlist>? playlists,
    bool? showLoading,
    bool? isAddButtonPressed,
    bool? isSelectionMode,
    Set<int>? selectedPlaylistIds,
  }) {
    return PlaylistsListState(
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
