import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_playlists/playlists/playlist_create/playlist_create_events.dart';
import 'package:mockingbird/tab_playlists/playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateWidget extends StatefulWidget {
  final PlaylistCreateEvents _handler;
  const PlaylistCreateWidget(this._handler, {super.key});

  static Future<({String name, File? cover})?> show(
    BuildContext context,
    PlaylistCreateEvents handler,
  ) async {
    return await showDialog<({String name, File? cover})?>(
      context: context,
      builder: (BuildContext context) {
        return PlaylistCreateWidget(handler);
      },
    );
  }

  @override
  State<PlaylistCreateWidget> createState() => _PlaylistCreateWidgetFactory();
}

class _PlaylistCreateWidgetFactory extends State<PlaylistCreateWidget> {
  PlaylistCreateState _state = const PlaylistCreateState();
  final TextEditingController nameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Rebuilds the UI every time the text changes so the "Create" button updates
    nameController.addListener(() {
      final newState = widget._handler.playlistCreateWidgetTypingName(
        _state,
        nameController.text,
      );
      _updateState(newState);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateState(PlaylistCreateState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Text(
        'Create New Playlist',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCoverWidget(),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              cursorColor: colorScheme.primary,
              decoration: InputDecoration(
                labelText: 'Playlist Name',
                hintText: 'Enter playlist name',
                prefixIcon: Icon(Icons.playlist_play, color: colorScheme.primary),
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        GestureDetector(
          onTap: _state.creatable ? _clickedCreate : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: _state.creatable
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.12),
            ),
            child: Text(
              'CREATE',
              style: TextStyle(
                color: _state.creatable
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: 0.38),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clickedCover() async {
    final XFile? xImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage != null) {
      File cover = File(xImage.path);
      final newState = widget._handler.playlistCreateWidgetSelectedCover(
        _state,
        cover,
      );
      _updateState(newState);
    }
  }

  Widget _buildCoverWidget() {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
      onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
      onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
      onTap: _clickedCover,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _state.cover != null
              ? Image.file(_state.cover!, fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select Cover',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _clickedCreate() {
    //TODO while(true) test async
    final incompletePlaylist = (name: nameController.text, cover: _state.cover);
    Navigator.of(context).pop(incompletePlaylist);
  }
}
