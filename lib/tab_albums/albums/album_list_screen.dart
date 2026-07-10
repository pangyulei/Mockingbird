import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/albums/album_list_provider.dart';
import 'package:mockingbird/tab_albums/albums/album_list_ui.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_screen.dart';

class AlbumListScreen extends ConsumerStatefulWidget {
  const AlbumListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlbumListScreenState();
}

class _AlbumListScreenState extends ConsumerState<AlbumListScreen>
    implements AlbumListUIOutputITF {
  Future<void> _showCreatingAlbumDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return const EditAlbumScreen(null);
      },
    );
  }

  Future<void> _showEditingAlbumDialog(int id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditAlbumScreen(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlbumListUI(this);
  }

  @override
  void albumsGrid_onAddAlbum() async {
    await _showCreatingAlbumDialog();
  }

  @override
  void albumCard_onDelete(int index) async {
    final name = ref.read(albumListProvider.notifier).nameForIndex(index);
    if (name == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Album'),
        content: Text(
          'Are you sure you want to delete "$name"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

    await ref.read(albumListProvider.notifier).deleteAlbum(index);
  }

  @override
  void albumCard_onEdit(int index) async {
    final id = ref.read(albumListProvider.notifier).idForIndex(index);
    if (id != null) {
      debugPrint('edit album $id');
      await _showEditingAlbumDialog(id);
    } else {
      debugPrint('on edit album but id is null');
    }
  }

  @override
  void albumCard_onTap(int index) {
    final id = ref.read(albumListProvider.notifier).idForIndex(index);
    if (id != null) {
      context.go(AppRoute.albumById(id));
    }
  }
}
