import 'package:flutter/material.dart';

abstract interface class PlaylistsNavInterfaceUIEvents {
  Route<dynamic>? playlistsNavOnGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> playlistsNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  );
}
