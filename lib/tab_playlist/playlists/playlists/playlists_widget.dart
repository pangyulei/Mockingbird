import 'package:flutter/material.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_handler.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_card/playlist_card_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_handler.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_widget.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlists/playlists_state.dart';

class PlaylistsWidget extends StatefulWidget {
  final PlaylistsEvents _handler;
  const PlaylistsWidget(this._handler, {super.key});

  @override
  State<PlaylistsWidget> createState() => _PlaylistsWidgetFactory();
}

class _PlaylistsWidgetFactory extends State<PlaylistsWidget> {
  PlaylistsState _state = const PlaylistsState();

  @override
  void initState() {
    super.initState();
    widget._handler.playlistsWidgetInitState().then((newState) {
      _updateState(newState);
    });
  }

  Future<void> _updateStateByStream(Stream<PlaylistsState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistsState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _clickedAdd() async {
    final incompletePlaylist = await PlaylistCreateWidget.show(
      context,
      PlaylistCreateHandler(),
    );
    final stream = widget._handler.playlistsWidgetPoppedCreateWidget(
      _state,
      incompletePlaylist,
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
          if (_state.isLoadingAll) _buildLoadingWidget(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _state.isSelectionMode
          ? Row(
              children: [
                Text(
                  '${_state.selectedPlaylistIds.length} selected',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Playlists',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_state.playlists.length} created playlists',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
      centerTitle: false,
      leading: _state.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                final newState = widget._handler
                    .playlistsWidgetToggleSelectionMode(_state);
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
                // Select All button
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
                // Delete button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _state.selectedPlaylistIds.isEmpty
                        ? Theme.of(context).disabledColor.withValues(alpha: 0.3)
                        : Theme.of(context).colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _state.selectedPlaylistIds.isEmpty
                        ? null
                        : () => _showDeleteConfirmation(),
                    icon: Icon(
                      Icons.delete,
                      color: _state.selectedPlaylistIds.isEmpty
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.38)
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              spacing: 0,
              children: [
                _buildActionButton(const Icon(Icons.edit, size: 22), () {}),
                _buildActionButton(
                  const Icon(Icons.playlist_add, size: 30),
                  _clickedAdd,
                ),
              ],
            ),
          ), //padding
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
      final stream = widget._handler.playlistsWidgetBatchRemoveSelected(_state);
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
              final newState = widget._handler
                  .playlistsWidgetToggleSelectionMode(_state);
              _updateState(newState);
            }
            // Toggle selection
            final toggleState = widget._handler
                .playlistsWidgetTogglePlaylistSelection(_state, playlist.id);
            _updateState(toggleState);
          },
          onTap: () {
            if (_state.isSelectionMode) {
              // In selection mode, tap toggles selection
              final toggleState = widget._handler
                  .playlistsWidgetTogglePlaylistSelection(_state, playlist.id);
              _updateState(toggleState);
            }
            // In normal mode, tap does nothing here - navigation is handled by PlaylistCardWidget
          },
          child: Stack(
            children: [
              PlaylistCardWidget(playlist, PlaylistCardHandler()),
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
                          : Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
