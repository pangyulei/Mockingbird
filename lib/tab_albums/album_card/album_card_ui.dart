import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum _MoreItem {
  delete('delete'),
  edit('edit');

  final String raw;

  const _MoreItem(this.raw);
}

abstract interface class AlbumCardNotifierITF {
  EnAlbum? get album;

  Future<void> delete();
}

class AlbumCardUI extends ConsumerWidget {
  final ProviderListenable<AlbumCardState> _provider;
  final AlbumCardNotifierITF _notifier;

  const AlbumCardUI(
    this._provider,
    this._notifier, {
    super.key,
  });

  void _onTap(BuildContext ctx) {
    final id = _notifier.album?.id;
    if (id != null) ctx.go(AppRoute.albumById(id));
  }

  void _onEdit(BuildContext ctx) async {
    await _showEditAlbumDialog(ctx);
  }

  void _onDelete(BuildContext ctx, WidgetRef ref) async {
    if (await confirmDelete(ctx, ref)) {
      await _notifier.delete();
    }
  }

  Future<bool> confirmDelete(
    BuildContext ctx,
    WidgetRef ref,
  ) async {
    final name = _notifier.album?.name;
    if (name == null) {
      return false;
    }
    final confirmed = await showDialog<bool>(
      context: ctx,
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
              backgroundColor: Theme.of(
                context,
              ).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == null || !confirmed) {
      return false;
    }
    return true;
  }

  Future<void> _showEditAlbumDialog(
    BuildContext ctx,
  ) async {
    await showDialog(
      context: ctx,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final provider = editAlbumProvider(
              _notifier.album,
            );
            final notifier = ref.read(provider.notifier);
            return EditAlbumUI(provider, notifier);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => _onTap(ctx),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.2,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _cover(ctx, ref),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(
                                alpha: 0.3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _menu(ctx, ref),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Name and song count below cover
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final name = ref.watch(
                      _provider.select((s) => s.name),
                    );
                    return Text(
                      name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                const SizedBox(height: 2),
                Consumer(
                  builder: (context, ref, child) {
                    final mediasCount =
                        ref.watch(
                          _provider.select(
                            (s) => s.mediasCount,
                          ),
                        ) ??
                        0;
                    return Text(
                      '$mediasCount Medias',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w500,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext ctx, WidgetRef ref) {
    final colorScheme = Theme.of(ctx).colorScheme;
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_horiz,
        size: 20,
        color: Colors.white,
      ),
      onSelected: (value) {
        if (value == _MoreItem.edit.raw) {
          _onEdit(ctx);
        } else if (value == _MoreItem.delete.raw) {
          _onDelete(ctx, ref);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreItem.edit.raw,
          child: const Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 12),
              Text('Edit Album'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MoreItem.delete.raw,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ),
        ),
      ],
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(
          alpha: 0.3,
        ),
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _cover(BuildContext ctx, WidgetRef ref) {
    final cover = ref.watch(
      _provider.select((s) => s.cover),
    );
    final colorScheme = Theme.of(ctx).colorScheme;
    if (cover != null) {
      return Image.file(File(cover), fit: BoxFit.cover);
    } else {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.album_rounded,
            color: colorScheme.primary.withValues(
              alpha: 0.5,
            ),
            size: 48,
          ),
        ),
      );
    }
  }
}
