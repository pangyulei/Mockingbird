import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_logic.dart';
import 'package:mockingbird/tab_playlists/playlist_detail/playlist_detail_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_logic.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_nav/playlists_nav_interface_ui_events.dart';

import 'playlists_nav_route.dart';

class PlaylistsNavLogic implements PlaylistsNavInterfaceUIEvents {
  const PlaylistsNavLogic();

  @override
  Route<dynamic>? playlistsNavOnGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _widgetByURLStr(settings.name!);
    } else {
      return null;
    }
  }

  Route<dynamic> _widgetByURLStr(String urlStr) {
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
            segments.first == PlaylistsNavRoute.playlists) {
          return const PlaylistsGridWidget(PlaylistsGridLogic());
        } else if (segments.length == 2 &&
            segments.first == PlaylistsNavRoute.playlists) {
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
  List<Route<dynamic>> playlistsNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  ) {
    return [
      PlaylistsNavRoute.urlStrForPlaylists(),
      // TabPlaylistRoute.urlStrForPlaylist(
      //   'default',
      // ), //TODO not 100% is default, may edited name
    ].map((urlStr) => _widgetByURLStr(urlStr)).toList();
  }
}
