import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/tab_albums/album/album_screen.dart';
import 'package:mockingbird/tab_albums/albums/albums_screen.dart';
import 'package:mockingbird/tab_player/player/player_screen.dart';
import 'package:mockingbird/tab_settings/tab_settings_widget.dart';

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

  //TODO 这些属性谁在用 _kXXXXX
  //TODO 变成实例方法
  static const String _kAlbums = 'albums';

  static String get albums => '/$_kAlbums';

  static String albumById(int id) => '/$_kAlbums/$id';

  static const String _kPlayer = 'player';

  static String get player => '/$_kPlayer';

  static String playerById(int id) => '/$_kPlayer/$id';

  static const String _kSettings = 'settings';

  static String get settings => '/$_kSettings';

  static GoRouter _router(OnAppTab onAppTab) => GoRouter(
    initialLocation: AppRoute.albums,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            _indexesStackScaffold(ctx, shell, onAppTab),
        branches: [
          StatefulShellBranch(routes: [_albumsRoute()]),
          StatefulShellBranch(routes: [_playerRoute()]),
          StatefulShellBranch(routes: [_settingsRoute()]),
        ],
      ),
    ],
  );

  static GoRoute _albumsRoute() => GoRoute(
    path: AppRoute.albums,
    builder: (BuildContext context, GoRouterState state) {
      return const AlbumsScreen();
    },
    routes: <RouteBase>[
      // Sub-route: Accessible via '/details'
      GoRoute(
        path: ':id',
        builder: (BuildContext context, GoRouterState state) {
          final albumIdStr = state.pathParameters['id']!;
          final albumId = int.tryParse(albumIdStr);
          if (albumId != null) {
            return AlbumScreen(albumId);
          }
          return const AlbumsScreen();
        },
      ),
    ],
  );

  static GoRoute _playerRoute() => GoRoute(
    path: AppRoute.player,
    builder: (BuildContext context, GoRouterState state) {
      return const PlayerScreen(null);
    },
    routes: <RouteBase>[
      GoRoute(
        path: ':id',
        builder: (ctx, state) {
          final mediaIdStr = state.pathParameters['id']!;
          final mediaId = int.tryParse(mediaIdStr);
          if (mediaId != null) {
            return PlayerScreen(mediaId);
          }
          return const PlayerScreen(null);
        },
      ),
    ],
  );

  static GoRoute _settingsRoute() => GoRoute(
    path: AppRoute.settings,
    builder: (BuildContext context, GoRouterState state) {
      return const TabSettingsWidget();
    },
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
