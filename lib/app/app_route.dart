import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_ui.dart';
import 'package:mockingbird/tab_player/player/player_ui.dart';
import 'package:mockingbird/tab_settings/about_ui.dart';

import '../tab_settings/settings_ui.dart';

typedef OnAppTab = void Function(int index, StatefulNavigationShell shell);

class AppRoute {
  static AppRoute? _instance;
  final GoRouter router;

  AppRoute._(this.router);

  factory AppRoute(OnAppTab onAppTab) {
    final instance = _instance;
    if (instance == null) {
      final newInstance = AppRoute._(_router(onAppTab));
      _instance = newInstance;
      return newInstance;
    } else {
      return instance;
    }
  }

  static String get albums => '/albums';

  // static String get addAlbum => '$albums/new';
  static String albumDetail(int id) => '$albums/$id';

  // static String editAlbum(int id) => '$albums/$id/edit';

  static String get player => '/player';

  // static String playerById(int id) => '$player/$id';

  static String get settings => '/settings';

  static String get about => '$settings/about';

  static GoRouter _router(OnAppTab onAppTab) => GoRouter(
    initialLocation: AppRoute.albums,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => _indexesStackScaffold(ctx, shell, onAppTab),
        branches: [
          StatefulShellBranch(routes: [_albumsRoute()]),
          StatefulShellBranch(routes: [_playerRoute()]),
          StatefulShellBranch(routes: [_settingsRoute()]),
        ],
      ),
    ],
  );

  static GoRoute _albumsRoute() => GoRoute(
    path: albums,
    builder: (context, state) => const AlbumListUI(),
    routes: <RouteBase>[
      // GoRoute(
      //   path: 'new',
      //   builder: (context, state) => const EditAlbumUI(null),
      // ),
      GoRoute(
        path: ':id',
        builder: (BuildContext context, GoRouterState state) {
          final albumIdStr = state.pathParameters['id'];
          final albumId = albumIdStr == null ? null : int.tryParse(albumIdStr);
          return AlbumDetailUI(albumId);
        },
      ),
      // GoRoute(
      //   path: ':id/edit',
      //   builder: (context, state) {
      //     final albumIdStr = state.pathParameters['id'];
      //     final albumId = albumIdStr == null ? null : int.tryParse(albumIdStr);
      //     return EditAlbumUI(albumId);
      //   },
      // ),
    ],
  );

  static GoRoute _playerRoute() => GoRoute(
    path: AppRoute.player,
    builder: (BuildContext context, GoRouterState state) {
      return const PlayerUI();
    },
  );

  static GoRoute _settingsRoute() => GoRoute(
    path: AppRoute.settings,
    builder: (BuildContext context, GoRouterState state) {
      return const SettingsUI();
    },
    routes: [GoRoute(path: 'about', builder: (context, state) => const AboutUI())],
  );

  static Widget _indexesStackScaffold(
    BuildContext ctx,
    StatefulNavigationShell shell,
    OnAppTab onAppTab,
  ) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.3),
              // width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: shell.currentIndex,
          onTap: (index) {
            onAppTab(index, shell);
            // _logic.app_selectedIndex(index, shell);
          },
          elevation: 0,
          backgroundColor: const Color(0xFF17212B),
          selectedItemColor: const Color(0xFF5288C1),
          unselectedItemColor: const Color(0xFF7F91A4),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.album_outlined),
              activeIcon: Icon(Icons.album),
              label: 'Albums',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle),
              label: 'Player',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
