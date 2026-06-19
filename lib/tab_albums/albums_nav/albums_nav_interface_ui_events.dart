import 'package:flutter/material.dart';

abstract interface class AlbumsNavInterfaceUIEvents {
  Route<dynamic>? albumsNavOnGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> albumsNavOnGenerateInitialRoute(
    NavigatorState navigator,
    String initialRoute,
  );
}
