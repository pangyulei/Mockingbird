import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_album.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_provider.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class AlbumDetailNotifierITF {
  EnAlbum? get album;

  EnMedia? mediaAtIndex(int i);

  Future<void> import();

  Future<void> addCover();
}

class AlbumDetailUI extends ConsumerWidget {
  final ProviderListenable<AlbumDetailState> _provider;
  final AlbumDetailNotifierITF _notifier;

  const AlbumDetailUI(this._provider, this._notifier, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return Stack(children: [_page(ctx, ref)]);
  }

  Widget _page(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(ctx),
          Consumer(
            builder: (context, ref, child) {
              final mediaCount = ref.watch(
                _provider.select((s) => s.mediaCount),
              );
              if (mediaCount > 0) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final media = _notifier.mediaAtIndex(i);
                      final provider = mediaCardProvider(media);
                      final notifier = ref.read(provider.notifier);
                      return MediaCardUI(provider, notifier);
                    }, childCount: mediaCount),
                  ),
                );
              } else {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: InkWell(
                    onTap: _onImport,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.library_add_outlined,
                            size: 64,
                            color: theme.colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No media in this album',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to import audio or video files',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _sliverAppBar(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Consumer(
          builder: (ctx, ref, child) {
            final (name, cover) = ref.watch(
              _provider.select((s) => (s.name, s.cover)),
            );
            return Text(
              name,
              style: TextStyle(
                color: cover != null ? Colors.white : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                shadows: cover != null
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        background: Consumer(
          builder: (ctx, ref, child) {
            final cover = ref.watch(_provider.select((s) => s.cover));
            if (cover == null) {
              return _noCoverBanner(ctx, ref);
            } else {
              return _coverBanner(ctx, cover);
            }
          },
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          onPressed: () => Navigator.pop(ctx),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      actions: [
        Consumer(
          builder: (ctx, ref, child) {
            final showImport = ref.watch(
              _provider.select((st) => st.showImport),
            );
            if (showImport) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton.filledTonal(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: _onImport,
                  tooltip: 'Add Media',
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _coverBanner(BuildContext ctx, File cover) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(cover, fit: BoxFit.cover),
        InkWell(
          onTap: _onPickCover,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.7, 1.0],
                colors: [
                  Colors.black38,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black87,
                ],
              ),
            ),
          ),
        ),
        Positioned(right: 16, bottom: 16, child: _editAlbumButton(ctx)),
      ],
    );
  }

  Widget _editAlbumButton(BuildContext ctx) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return FloatingActionButton.small(
      onPressed: () => _onEditAlbum(ctx),
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      foregroundColor: colorScheme.primary,
      child: const Icon(Icons.edit_outlined),
    );
  }

  Widget _noCoverBanner(BuildContext ctx, WidgetRef ref) {
    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: _onPickCover,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 64,
                    color: colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add Cover Photo',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(right: 16, bottom: 16, child: _editAlbumButton(ctx)),
        ],
      ),
    );
  }

  void _onImport() async {
    await _notifier.import();
  }

  void _onPickCover() async {
    await _notifier.addCover();
  }

  void _onEditAlbum(BuildContext ctx) async {
    await _showEditingAlbumDialog(ctx);
  }

  Future<void> _showEditingAlbumDialog(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final provider = editAlbumProvider(_notifier.album);
            final notifier = ref.read(provider.notifier);
            return EditAlbumUI(provider, notifier);
          },
        );
      },
    );
  }
}
