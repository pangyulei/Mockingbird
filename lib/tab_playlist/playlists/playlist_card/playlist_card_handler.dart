import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_state.dart';

class PlaylistCardHandler implements PlaylistCardEvents {
  @override
  PlaylistCardState playlistCardWidgetClickedDown(PlaylistCardState state) {
    return state.copyWith(isPressed: true);
  }

  @override
  PlaylistCardState playlistCardWidgetClickedUpInside(PlaylistCardState state) {
    // This is where you would put navigation logic in the future
    return state.copyWith(isPressed: false);
  }

  @override
  PlaylistCardState playlistCardWidgetClickedUpOutside(PlaylistCardState state) {
    return state.copyWith(isPressed: false);
  }
}
