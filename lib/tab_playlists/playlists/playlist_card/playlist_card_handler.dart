import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists/playlist_card/playlist_card_events.dart';
import 'package:mockingbird/tab_playlists/playlists/playlist_card/playlist_card_state.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_route.dart';

class PlaylistCardHandler implements PlaylistCardEvents {
  const PlaylistCardHandler();

  @override
  PlaylistCardState playlistCardWidgetPressedStateChanged(
    PlaylistCardState state,
    bool isPressed,
  ) {
    return state.copyWith(isPressed: isPressed);
  }

  @override
  void playlistCardWidgetOnTap(BuildContext context, Playlist playlist) {
    Navigator.pushNamed(
      context,
      TabPlaylistsRoute.urlStrForPlaylist(playlist.id),
    );
  }
}
