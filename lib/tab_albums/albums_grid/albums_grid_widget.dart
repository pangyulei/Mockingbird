import 'package:flutter/material.dart';

import '../album_create/album_create_logic.dart';
import '../album_create/album_create_widget.dart';
import 'album_card/album_card_logic.dart';
import 'album_card/album_card_widget.dart';
import 'albums_grid_interface_ui_events.dart';
import 'albums_grid_state.dart';

class AlbumsGridWidget extends StatefulWidget {
  final AlbumsGridInterfaceUIEvents _logic;
  const AlbumsGridWidget(this._logic, {super.key});

  @override
  State<AlbumsGridWidget> createState() => _WidgetFactory();
}

class _WidgetFactory extends State<AlbumsGridWidget> {
  AlbumsGridState _state = const AlbumsGridState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(widget._logic.albumsGridInitState());
  }

  Future<void> _updateStateByStream(Stream<AlbumsGridState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(AlbumsGridState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _clickedAdd() async {
    final newPlaylistInfo = await AlbumCreateWidget.show(
      context,
      const AlbumCreateLogic(),
    );
    final stream = widget._logic.albumsGridPoppedCreateWidget(
      _state,
      newPlaylistInfo,
    );
    await _updateStateByStream(stream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          _gridWidget(),
          if (_state.showLoading) _loadingWidget(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: _state.isSelectionMode
          ? Text('${_state.selectedAlbumIds.length} selected')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Playlists'),
                Text(
                  '${_state.albums.length} created playlists',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
      centerTitle: false,
      leading: _state.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                final newState = widget._logic
                    .albumsGridToggleSelectionMode(_state);
                _updateState(newState);
              },
            )
          : null,
      actions: [
        if (_state.isSelectionMode)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              spacing: 8,
              children: [
                if (_state.selectedAlbumIds.length < _state.albums.length)
                  TextButton(
                    onPressed: () {
                      final allIds = _state.albums.map((p) => p.id).toSet();
                      _updateState(
                        _state.copyWith(selectedAlbumIds: allIds),
                      );
                    },
                    child: const Text('Select All'),
                  ),
                IconButton.filledTonal(
                  onPressed: _state.selectedAlbumIds.isEmpty
                      ? null
                      : () => _showDeleteConfirmation(),
                  icon: const Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    backgroundColor: _state.selectedAlbumIds.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: _state.selectedAlbumIds.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              onPressed: _clickedAdd,
              icon: const Icon(Icons.playlist_add),
            ),
          ),
      ],
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlists'),
        content: Text(
          'Are you sure you want to delete ${_state.selectedAlbumIds.length} playlist(s)? This action cannot be undone.',
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

    if (confirmed == true) {
      final stream = widget._logic.albumsGridBatchRemoveSelected(_state);
      await _updateStateByStream(stream);
    }
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _gridWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _state.albums.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final playlist = _state.albums[index];
        final isSelected = _state.isAlbumSelected(playlist.id);

        return GestureDetector(
          onLongPress: () {
            if (!_state.isSelectionMode) {
              final newState = widget._logic.albumsGridToggleSelectionMode(
                _state,
              );
              _updateState(newState);
            }
            // Toggle selection
            final toggleState = widget._logic
                .albumsGridToggleAlbumSelection(_state, playlist.id);
            _updateState(toggleState);
          },
          onTap: () {
            if (_state.isSelectionMode) {
              // In selection mode, tap toggles selection
              final toggleState = widget._logic
                  .albumsGridToggleAlbumSelection(_state, playlist.id);
              _updateState(toggleState);
            }
            // In normal mode, tap does nothing here - navigation is handled by PlaylistsListCardWidget
          },
          child: Stack(
            children: [
              AlbumCardWidget(playlist, const AlbumCardLogic()),
              // Selection indicator overlay
              if (_state.isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
