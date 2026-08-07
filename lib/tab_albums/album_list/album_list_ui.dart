import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_ui.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_provider.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:mockingbird/tool/shrink_ui.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../tool/extensions.dart';

class AlbumListUI extends ConsumerStatefulWidget {
  const AlbumListUI({super.key});

  @override
  ConsumerState<AlbumListUI> createState() => _AlbumListUIState();
}

class _AlbumListUIState extends ConsumerState<AlbumListUI> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(albumListProvider);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final stateType = ref.watch(albumListProvider.select((st) => st.value?.runtimeType));
    debugPrint('albumlist stateType: $stateType');
    // showLoading(stateType == null);
    switch (stateType) {
      case AlbumListNotYetRequested:
        return _pageForRequestPermissions();
      case AlbumListPermissionDenied:
        return _pageForGrantPermissionsViaSetting();
      case AlbumListEmpty:
        return _empty();
      case AlbumListData:
        return _page();
      default:
        //Null/null, means its asyncloading without data, initial load situation
        return Scaffold(appBar: _appBar());
    }
  }

  Widget _empty() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.collections_bookmark_rounded,
                  size: 80,
                  color: colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No Albums Found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Organize your audio and video clips into albums for better shadowing practice.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageForRequestPermissions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: colorScheme.primary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Permission Required',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mockingbird needs access to your media library to find and organize your audio and video clips.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await ref.read(albumListProvider.notifier).requestPermission();
                },
                icon: const Icon(Icons.settings_suggest_rounded),
                label: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageForGrantPermissionsViaSetting() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_applications_rounded,
                  size: 80,
                  color: colorScheme.error.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Settings Access Needed',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Permission was denied. Please go to system settings to manually allow Mockingbird access to your media.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await PhotoManager.openSetting();
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _page() {
    return Scaffold(appBar: _appBar(), body: _grid());
  }

  AppBar _appBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Consumer(
            builder: (context, ref, child) {
              final int? albumCount = ref.watch(
                albumListProvider.select((st) => st.value?.as<AlbumListData>()?.albumIdList.length),
              );
              if (albumCount == null) return const ShrinkUI();
              return Text(
                '$albumCount albums',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
              );
            },
          ),
        ],
      ),
      centerTitle: false,
      actions: const [],
    );
  }

  Widget _grid() {
    //grid has to watch whole albumlist, because its order may change, but count stay same.

    return Consumer(
      builder: (context, ref, child) {
        //watch all, albumCount may not change but the album inside list already change
        //etc. album order updated
        final albumIdList = ref.watch(
          albumListProvider.select((st) => st.value?.as<AlbumListData>()?.albumIdList),
        );
        if (albumIdList == null) return const ShrinkUI();
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: albumIdList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (ctx, i) {
            return AlbumCardUI(albumIdList[i]);
          },
        );
      },
    );
  }
}
