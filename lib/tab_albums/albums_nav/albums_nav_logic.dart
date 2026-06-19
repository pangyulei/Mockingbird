import 'package:flutter/material.dart';
import '../album_detail/album_detail_logic.dart';
import '../album_detail/album_detail_widget.dart';
import '../albums_grid/albums_grid_logic.dart';
import '../albums_grid/albums_grid_widget.dart';
import 'albums_nav_interface_ui_events.dart';
import 'albums_nav_route.dart';

class AlbumsNavLogic implements AlbumsNavInterfaceUIEvents {
  const AlbumsNavLogic();

  @override
  Route<dynamic>? albumsNavOnGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _widgetByURLStr(settings.name!);
    } else {
      return null;
    }
  }

  Route<dynamic> _widgetByURLStr(String urlStr) {
    /*
    /albums
    /albums/42
    /albums/42/edit
      */
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(urlStr);
        // ['albums', '42']
        final segments = uri.pathSegments;
        if (segments.length == 1 &&
            segments.first == AlbumsNavRoute.albums) {
          return const AlbumsGridWidget(AlbumsGridLogic());
        } else if (segments.length == 2 &&
            segments.first == AlbumsNavRoute.albums) {
          final albumIdStr = segments.last;
          final albumId = int.tryParse(albumIdStr);
          if (albumId != null) {
            return AlbumDetailWidget(
              AlbumDetailLogic(albumId: albumId),
            );
          } else {
            throw Exception('Invalid album ID: $albumIdStr');
          }
        } else {
          throw Exception('$urlStr is not defined');
        }
      },
    );
  }

  @override
  List<Route<dynamic>> albumsNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  ) {
    return [
      AlbumsNavRoute.urlStrForAlbums(),
      // TabAlbumRoute.urlStrForAlbumDetail(
      //   'default',
      // ), //TODO not 100% is default, may edited name
    ].map((urlStr) => _widgetByURLStr(urlStr)).toList();
  }
}
