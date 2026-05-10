import 'package:flutter/material.dart';

abstract interface class TabPlaylistsEvents {
  Route<dynamic>? tabPlaylistsOnGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> tabPlaylistsOnGenerateInitialRoute(NavigatorState navigator, String initialRoute);
}
