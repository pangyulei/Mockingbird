import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_logic.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_widget.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_logic.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_ui.dart';

import 'route_albums.dart';

class UIAlbumsNav extends StatelessWidget {
  const UIAlbumsNav({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: _onGenerateRoute,
      onGenerateInitialRoutes: _onGenerateInitialRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      return _widgetByURL(settings.name!);
    } else {
      return null;
    }
  }

  List<Route<dynamic>> _onGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  ) {
    return [
      RouteAlbums.albums,
      // TabAlbumRoute.urlStrForAlbumDetail(
      //   'default',
      // ), //TODO not 100% is default, may edited name
    ].map((url) => _widgetByURL(url)).toList();
  }

  Route<dynamic> _widgetByURL(String url) {
    /*
    /albums
    /albums/42
    /albums/42/edit
      */
    return MaterialPageRoute(
      builder: (context) {
        final uri = Uri.parse(url);
        // ['albums', '42']
        final segments = uri.pathSegments;
        if (segments.length == 1 && segments.first == RouteAlbums.kAlbums) {
          return AlbumsGridUI(AlbumsGridLogic());
        } else if (segments.length == 2 &&
            segments.first == RouteAlbums.kAlbums) {
          final albumIdStr = segments.last;
          final albumId = int.tryParse(albumIdStr);
          if (albumId != null) {
            return AlbumDetailWidget(AlbumDetailLogic(albumId: albumId));
          } else {
            throw Exception('Invalid album ID: $albumIdStr');
          }
        } else {
          throw Exception('$url is not defined');
        }
      },
    );
  }
}
