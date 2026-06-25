import 'dart:io';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot.dart';
import 'package:mockingbird/tab_albums/album_edit/ui_album_edit_snapshot_provider_itf.dart';

import 'album_edit_dumb.dart';

class UIAlbumEdit extends StatefulWidget {
  final UIAlbumEditSnapshotProviderITF _provider;
  const UIAlbumEdit(this._provider, {super.key});

  @override
  State<UIAlbumEdit> createState() => _UIAlbumEditState();
}

class _UIAlbumEditState extends State<UIAlbumEdit> {
  UIAlbumEditSnapshot get _snapshot => widget._provider.snapshot;
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _snapshot.name.addListener(() {
      if (_nameController.text != _snapshot.name.value) {
        _nameController.text = _snapshot.name.value;
      }
    });
    _nameController.addListener(() {
      if (_snapshot.name.value != _nameController.text) {
        widget._provider.albumEditNameChanged(_nameController.text);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //     cover: _cover,
  //     isSubmitEnabled: _isSubmitEnabled,
  //     onDeleteCover: _onDeleteCover,
  //     onPickCover: _onPickCover,
  //     onSubmit: () {
  //       widget._onSubmit?.call(_nameController.text, _cover);

  //     },
  //   )
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: ValueListenableBuilder(
        valueListenable: _snapshot.title,
        builder: (context, title, child) {
          return Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _coverWidget(context),
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
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder(
          valueListenable: _snapshot.enableSubmit,
          builder: (context, enableSubmit, child) {
            return FilledButton(
              onPressed: enableSubmit
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
              child: ValueListenableBuilder(
                valueListenable: _snapshot.submitTitle,
                builder: (context, submitTitle, child) {
                  return Text(submitTitle);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _coverWidget(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          // onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
          // onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
          // onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
          onTap: _onPickCover,
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
        ValueListenableBuilder(valueListenable: _snapshot.cover, builder: (context, cover, child) {
          if (cover != null) {
            return TextButton.icon(
              onPressed: _onDeleteCover,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Remove Cover'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        })
      ],
    );
  }

  Future<void> _onPickCover() async {
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    // if (xImage != null) {
    //   setState(() {
    //     _cover = File(xImage.path);
    //   });
    // }
  }

  void _onDeleteCover() {
    // setState(() {
    //   _cover = null;
    // });
  }
}
