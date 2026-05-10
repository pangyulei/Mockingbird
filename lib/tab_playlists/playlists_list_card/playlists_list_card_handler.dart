import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_list_card/playlists_list_card_events.dart';
import 'package:mockingbird/tab_playlists/playlists_list_card/playlists_list_card_state.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_route.dart';

class PlaylistsListCardHandler implements PlaylistsListCardEvents {
  const PlaylistsListCardHandler();

  @override
  PlaylistsListCardState playlistsListCardWidgetPressedStateChanged(
    PlaylistsListCardState state,
    bool isPressed,
  ) {
    return state.copyWith(isPressed: isPressed);
  }

  @override
  void playlistsListCardWidgetOnTap(BuildContext context, Playlist playlist) {
    Navigator.pushNamed(
      context,
      TabPlaylistsRoute.urlStrForPlaylist(playlist.id),
    );
  }
}
