import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';

abstract interface class AlbumDetailUIOutputITF
    implements MediaCardUIOutputITF {
  void albumDetail_onImport();
  void albumDetail_onPickCover();
}

class AlbumDetailUI extends StatelessWidget {
  final AlbumDetailState _state;
  final AlbumDetailUIOutputITF _logic;
  const AlbumDetailUI(this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_page(ctx), if (_state.showLoading) _loading()]);
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _page(BuildContext ctx) {
    final theme = Theme.of(ctx);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(ctx),
          if (_state.mediaStates.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.library_music_outlined,
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
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final mediaState = _state.mediaStates[index];
                  return MediaCardUI(index, mediaState, _logic);
                }, childCount: _state.mediaStates.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Text(
          _state.name,
          style: TextStyle(
            color: _state.cover != null ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            shadows: _state.cover != null
                ? [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_state.cover != null)
              Image.file(_state.cover!, fit: BoxFit.cover)
            else
              Container(
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
                child: InkWell(
                  onTap: _logic.albumDetail_onPickCover,
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
              ),
            if (_state.cover != null)
              const DecoratedBox(
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
            // "Change Cover" floating button when cover exists
            if (_state.cover != null)
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.small(
                  heroTag: 'change_cover_fab',
                  onPressed: _logic.albumDetail_onPickCover,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  foregroundColor: colorScheme.primary,
                  child: const Icon(Icons.edit_outlined),
                ),
              ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      actions: [
        if (_state.showImport)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.add_rounded),
              onPressed: _logic.albumDetail_onImport,
              tooltip: 'Add Media',
            ),
          ),
      ],
    );
  }
}
