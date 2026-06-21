import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_albums/album_create/album_create_interface_ui_events.dart';
import 'package:mockingbird/tab_albums/album_create/album_create_state.dart';

class AlbumCreateWidget extends StatefulWidget {
  final AlbumCreateInterfaceUIEvents _handler;
  final String? initialName;
  final File? initialCover;

  const AlbumCreateWidget(
    this._handler, {
    this.initialName,
    this.initialCover,
    super.key,
  });

  static Future<({String name, File? coverFile})?> show(
    BuildContext context,
    AlbumCreateInterfaceUIEvents logic, {
    String? initialName,
    File? initialCover,
  }) async {
    return await showDialog<({String name, File? coverFile})?>(
      context: context,
      builder: (BuildContext context) {
        return AlbumCreateWidget(
          logic,
          initialName: initialName,
          initialCover: initialCover,
        );
      },
    );
  }

  @override
  State<AlbumCreateWidget> createState() => _WidgetFactory();
}

class _WidgetFactory extends State<AlbumCreateWidget> {
  late AlbumCreateState _state;
  late final TextEditingController nameController;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _state = AlbumCreateState(
      coverFile: widget.initialCover,
      creatable: widget.initialName?.isNotEmpty ?? false,
    );
    nameController = TextEditingController(text: widget.initialName);

    // Rebuilds the UI every time the text changes so the "Create" button updates
    nameController.addListener(() {
      final newState = widget._handler.albumCreateTypingName(
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

  void _updateState(AlbumCreateState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        widget.initialName != null ? 'Edit Album' : 'Create New Album',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _coverWidget(),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              cursorColor: colorScheme.primary,
              decoration: InputDecoration(
                labelText: 'Playlist Name',
                hintText: 'Enter playlist name',
                prefixIcon: Icon(
                  Icons.playlist_play,
                  color: colorScheme.primary,
                ),
              ),
              autofocus: widget.initialName == null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _state.creatable ? _clickedCreate : null,
          child: Text(widget.initialName != null ? 'SAVE' : 'CREATE'),
        ),
      ],
    );
  }

  void _clickedCover() async {
    //TODO move logic to handler
    final XFile? xImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage != null) {
      File cover = File(xImage.path);
      final newState = widget._handler.albumCreateSelectedCover(
        _state,
        cover,
      );
      _updateState(newState);
    }
  }

  Widget _coverWidget() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
          onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
          onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
          onTap: _clickedCover,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _state.coverFile != null
                  ? Image.file(_state.coverFile!, fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select Cover Image',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (_state.coverFile != null)
          TextButton.icon(
            onPressed: () {
              final newState = widget._handler.albumCreateRemoveCover(_state);
              _updateState(newState);
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove Cover'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
          ),
      ],
    );
  }

  void _clickedCreate() {
    //TODO while(true) test async
    final newPlaylistInfo = (name: nameController.text, coverFile: _state.coverFile);
    Navigator.of(context).pop(newPlaylistInfo);
  }
}
