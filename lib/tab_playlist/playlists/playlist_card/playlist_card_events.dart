import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

abstract interface class PlaylistCardEvents {
  PlaylistCardState playlistCardWidgetClickedDown(PlaylistCardState state);
  PlaylistCardState playlistCardWidgetClickedUpInside(PlaylistCardState state);
  PlaylistCardState playlistCardWidgetClickedUpOutside(PlaylistCardState state);
}
