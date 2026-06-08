import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_logic.dart';
import 'package:mockingbird/tab_playlists/playlist_create/playlist_create_widget.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_interface_ui_events.dart';
import 'package:mockingbird/tab_playlists/playlists_grid/playlists_grid_state.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_logic.dart';
import 'package:mockingbird/tab_playlists/playlists_grid_card/playlists_grid_card_widget.dart';

class PlaylistsGridWidget extends StatefulWidget {
  final PlaylistsGridInterfaceUIEvents _logic;
  const PlaylistsGridWidget(this._logic, {super.key});

  @override
  State<PlaylistsGridWidget> createState() => _PlaylistsGridWidgetFactory();
}

class _PlaylistsGridWidgetFactory extends State<PlaylistsGridWidget> {
  PlaylistsGridState _state = const PlaylistsGridState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(widget._logic.playlistsGridInitState());
  }

  Future<void> _updateStateByStream(Stream<PlaylistsGridState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistsGridState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _clickedAdd() async {
    final newPlaylistInfo = await PlaylistCreateWidget.show(
      context,
      const PlaylistCreateLogic(),
    );
    final stream = widget._logic.playlistsGridPoppedCreateWidget(
      _state,
      newPlaylistInfo,
    );
    await _updateStateByStream(stream);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildGridWidget(),
          if (_state.showLoading) _buildLoadingWidget(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _state.isSelectionMode
          ? Text('${_state.selectedPlaylistIds.length} selected')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Playlists'),
                Text(
                  '${_state.playlists.length} created playlists',
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
                    .playlistsGridToggleSelectionMode(_state);
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
                if (_state.selectedPlaylistIds.length < _state.playlists.length)
                  TextButton(
                    onPressed: () {
                      final allIds = _state.playlists.map((p) => p.id).toSet();
                      _updateState(
                        _state.copyWith(selectedPlaylistIds: allIds),
                      );
                    },
                    child: const Text('Select All'),
                  ),
                IconButton.filledTonal(
                  onPressed: _state.selectedPlaylistIds.isEmpty
                      ? null
                      : () => _showDeleteConfirmation(),
                  icon: const Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    backgroundColor: _state.selectedPlaylistIds.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: _state.selectedPlaylistIds.isEmpty
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
          'Are you sure you want to delete ${_state.selectedPlaylistIds.length} playlist(s)? This action cannot be undone.',
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
      final stream = widget._logic.playlistsGridBatchRemoveSelected(_state);
      await _updateStateByStream(stream);
    }
  }

  Widget _buildActionButton(Icon icon, void Function() onTap) {
    return SizedBox(
      width: 50,
      height: double.infinity,
      child: IconButton(onPressed: onTap, icon: icon),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGridWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _state.playlists.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final playlist = _state.playlists[index];
        final isSelected = _state.isPlaylistSelected(playlist.id);

        return GestureDetector(
          onLongPress: () {
            if (!_state.isSelectionMode) {
              final newState = widget._logic.playlistsGridToggleSelectionMode(
                _state,
              );
              _updateState(newState);
            }
            // Toggle selection
            final toggleState = widget._logic
                .playlistsGridTogglePlaylistSelection(_state, playlist.id);
            _updateState(toggleState);
          },
          onTap: () {
            if (_state.isSelectionMode) {
              // In selection mode, tap toggles selection
              final toggleState = widget._logic
                  .playlistsGridTogglePlaylistSelection(_state, playlist.id);
              _updateState(toggleState);
            }
            // In normal mode, tap does nothing here - navigation is handled by PlaylistsListCardWidget
          },
          child: Stack(
            children: [
              PlaylistsGridCardWidget(playlist, const PlaylistsGridCardLogic()),
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
