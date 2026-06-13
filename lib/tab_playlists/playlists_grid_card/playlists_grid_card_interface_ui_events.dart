import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_state.dart';

abstract interface class PlaylistsGridCardInterfaceUIEvents {
  PlaylistsGridCardState playlistsGridCardInitState(Playlist playlist);
  PlaylistsGridCardState playlistsGridCardPressedStateChanged(
    PlaylistsGridCardState state,
    bool isPressed,
  );
  void playlistsGridCardOnTap(BuildContext context, Playlist playlist);
}
