import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_state.dart';

abstract interface class PlaylistsGridCardInterfaceUIEvents {
  PlaylistsGridCardState playlistsGridCardPressedStateChanged(
    PlaylistsGridCardState state,
    bool isPressed,
  );
  void playlistsGridCardOnTap(BuildContext context, Album playlist);
}
