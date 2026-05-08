import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

abstract interface class PlaylistCardEvents {
  PlaylistCardState playlistCardWidgetPressedStateChanged(PlaylistCardState state, bool isPressed);
  void playlistCardWidgetOnTap(Playlist playlist);
}
