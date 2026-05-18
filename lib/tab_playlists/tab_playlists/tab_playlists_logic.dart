import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_logic.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_logic.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_widget.dart';
import 'package:mockingbird/tab_playlists/tab_playlists/tab_playlists_interface_ui_events.dart';

import 'tab_playlists_route.dart';

class TabPlaylistsLogic implements TabPlaylistsInterfaceUIEvents {
  const TabPlaylistsLogic();

  @override
  Route<dynamic>? tabPlaylistsOnGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _buildWidgetByURLStr(settings.name!);
    } else {
      return null;
    }
  }

  Route<dynamic> _buildWidgetByURLStr(String urlStr) {
    /*
    /playlists           -> playlist list page
    /playlists/42        -> playlist songs
    /playlists/42/edit   -> edit playlist
      */
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(urlStr);
        // ['playlists', '42']
        final segments = uri.pathSegments;
        if (segments.length == 1 &&
            segments.first == TabPlaylistsRoute.playlists) {
          return const PlaylistsGridWidget(PlaylistsGridLogic());
        } else if (segments.length == 2 &&
            segments.first == TabPlaylistsRoute.playlists) {
          final playlistIdStr = segments.last;
          final playlistId = int.tryParse(playlistIdStr);
          if (playlistId != null) {
            return PlaylistDetailWidget(
              playlistId,
              const PlaylistDetailLogic(),
            );
          } else {
            throw Exception('Invalid playlist ID: $playlistIdStr');
          }
        } else {
          throw Exception('$urlStr is not defined');
        }
      },
    );
  }

  @override
  List<Route<dynamic>> tabPlaylistsOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  ) {
    return [
      TabPlaylistsRoute.urlStrForPlaylists(),
      // TabPlaylistRoute.urlStrForPlaylist(
      //   'default',
      // ), //TODO not 100% is default, may edited name
    ].map((urlStr) => _buildWidgetByURLStr(urlStr)).toList();
  }
}
