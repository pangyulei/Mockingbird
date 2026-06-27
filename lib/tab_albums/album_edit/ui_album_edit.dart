import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_events.dart';

import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider_itf.dart';
import 'package:mockingbird/tool/broadcaster.dart';

class UIAlbumEdit extends StatefulWidget {
  final UIAlbumEditSnapshotProviderITF _provider;
  final String _title;
  final String _submitTitle;

  const UIAlbumEdit({
    required this._provider,
    required this._title,
    required this._submitTitle,
    super.key,
  });

  @override
  State<UIAlbumEdit> createState() => _UIAlbumEditState();
}

class _UIAlbumEditState extends State<UIAlbumEdit> {
  UIAlbumEditSnapshot get _snapshot => widget._provider.snapshot;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _snapshot.name.addListener(() {
      _nameController.text = _snapshot.name.value;
    });
    _nameController.addListener(() {
      widget._provider.albumEditNameChanged(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        widget._title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cover(context),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                labelText: 'Album Name',
                hintText: 'Enter Album name',
                prefixIcon: Icon(
                  Icons.playlist_play,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Broadcaster().emit<UIAlbumEditEvent>(const UIAlbumEditEventOnCancel()),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder(
          valueListenable: _snapshot.enableSubmit,
          builder: (context, enableSubmit, child) {
            return FilledButton(
              onPressed: enableSubmit ? widget._provider.albumEditOnSubmit : null,
                     
              child: Text(widget._submitTitle),
            );
          },
        ),
      ],
    );
  }

  Widget _cover(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          // onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
          // onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
          // onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
          onTap: widget._provider.albumEditOnPickCover,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ValueListenableBuilder(
                valueListenable: _snapshot.cover,
                builder: (context, cover, child) {
                  if (cover != null) {
                    return Image.file(cover, fit: BoxFit.cover);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select Cover Image',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _snapshot.cover,
          builder: (context, cover, child) {
            if (cover != null) {
              return TextButton.icon(
                onPressed: widget._provider.albumEditOnRemoveCover,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Remove Cover'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
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
}
