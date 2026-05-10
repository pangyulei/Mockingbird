import 'package:flutter/material.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlists/playlists_list_card/playlists_list_card_state.dart';

abstract interface class PlaylistsListCardEvents {
  PlaylistsListCardState playlistsListCardWidgetPressedStateChanged(
    PlaylistsListCardState state,
    bool isPressed,
  );
  void playlistsListCardWidgetOnTap(BuildContext context, Playlist playlist);
}
