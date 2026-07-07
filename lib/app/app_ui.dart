import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_screen.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_screen.dart';
import 'package:mockingbird/tab_player/player/player_screen.dart';
import 'package:mockingbird/tab_settings/tab_settings_widget.dart';

abstract interface class AppUIOutputITF {
  void app_selectedIndex(int index, StatefulNavigationShell shell);
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
          builder: (ctx, state, shell) => _indexesStackScaffold(ctx, shell),
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
              return AlbumDetailScreen(albumId);
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
  }

  GoRoute _settingsRoute() {
    return GoRoute(
      path: AppRoute.settings,
      builder: (BuildContext context, GoRouterState state) {
        return const TabSettingsWidget();
      },
    );
  }

  Widget _indexesStackScaffold(
    BuildContext ctx,
    StatefulNavigationShell shell,
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
            _logic.app_selectedIndex(index, shell);
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

  ThemeData _theme() {
    const background = Color(0xFF0E1621);
    const surface = Color(0xFF17212B);
    const primary = Color(0xFF5288C1);
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFF7F91A4);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: textPrimary,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: Color(0xFF242F3D),
        primaryContainer: Color(0xFF1D2A39),
        onPrimaryContainer: textPrimary,
        secondary: primary,
        outline: textSecondary,
        outlineVariant: Color(0xFF242F3D),
      ),
      scaffoldBackgroundColor: background,
      canvasColor: surface,
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          titleLarge: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
          labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.05),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: primary),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textPrimary,
        elevation: 4,
      ),
    );
  }
}
