import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/app/app_state.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_logic.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_widget.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_screen.dart';
import 'package:mockingbird/tab_player/player/player_widget.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_logic.dart';
import 'package:mockingbird/tab_player/player_nav/player_nav_widget.dart';
import 'package:mockingbird/tab_settings/tab_settings_widget.dart';

abstract interface class AppUIOutputITF {
  void app_selectedTab(AppTab tab, StatefulNavigationShell shell);
}

class AppUI extends StatelessWidget {
  final AppUIOutputITF _logic;
  const AppUI(this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _goRouter(),
      theme: _theme(),
      // builder: (context, child) => _home(),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: _theme(),
    //   home: _home(),
    // );
  }

  GoRouter _goRouter() {
    // Define the router configuration
    return GoRouter(
      initialLocation: AppRoute.albums,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (ctx, state, shell) => _indexesStackScaffold(shell),
          branches: [
            StatefulShellBranch(routes: [_albumsRoute()]),
            StatefulShellBranch(routes: [_playerRoute()]),
            StatefulShellBranch(routes: [_settingsRoute()]),
          ],
        ),
      ],
    );
  }

  GoRoute _albumsRoute() {
    return GoRoute(
      path: AppRoute.albums,
      builder: (BuildContext context, GoRouterState state) {
        return const AlbumsGridScreen();
      },
      routes: <RouteBase>[
        // Sub-route: Accessible via '/details'
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) {
            final albumIdStr = state.pathParameters['id']!;
            final albumId = int.tryParse(albumIdStr);
            if (albumId != null) {
              return AlbumDetailWidget(AlbumDetailLogic(albumId: albumId));
            }
            return const AlbumsGridScreen();
          },
        ),
      ],
    );
  }

  GoRoute _playerRoute() {
    return GoRoute(
      path: AppRoute.player,
      builder: (BuildContext context, GoRouterState state) {
        return const PlayerNavWidget(PlayerNavLogic());
      },
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (ctx, state) {
            final mediaIdStr = state.pathParameters['id']!;
            final mediaId = int.tryParse(mediaIdStr);
            if (mediaId != null) {
              return const PlayerNavWidget(PlayerNavLogic());
            }
            return const PlayerNavWidget(PlayerNavLogic());
          },          
        ),
      ],
    );
  }

  GoRoute _settingsRoute() {
    return GoRoute(
      path: AppRoute.settings,
      builder: (BuildContext context, GoRouterState state) {
        return const TabSettingsWidget();
      },
    );
  }

  Widget _indexesStackScaffold(StatefulNavigationShell shell) {
    return Scaffold(
      // ➔ 这里的 navigationShell 会在底层自动渲染出真正的 IndexedStack
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: (index) {
          _logic.app_selectedTab(AppTab.fromRaw(index), shell);
        },
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
    );
  }

  ThemeData _theme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005691),
        brightness: Brightness.light,
        primary: const Color(0xFF005691),
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: const Color(0xFF191C1E),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF191C1E),
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Color(0xFF191C1E),
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Color(0xFF191C1E)),
          bodyMedium: TextStyle(color: Color(0xFF42474E)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF191C1E),
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
    );
  }
}
