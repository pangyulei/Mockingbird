import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_state.dart';
import 'package:mockingbird/tab_playlists/playlists_nav/playlists_nav_route.dart';

class PlaylistsGridCardLogic implements PlaylistsGridCardInterfaceUIEvents {
  const PlaylistsGridCardLogic();

  @override
  PlaylistsGridCardState playlistsGridCardPressedStateChanged(
    PlaylistsGridCardState state,
    bool isPressed,
  ) {
    return state.copyWith(isPressed: isPressed);
  }

  @override
  void playlistsGridCardOnTap(BuildContext context, Album playlist) {
    Navigator.pushNamed(
      context,
      PlaylistsNavRoute.urlStrForPlaylist(playlist.id),
    );
  }
}
