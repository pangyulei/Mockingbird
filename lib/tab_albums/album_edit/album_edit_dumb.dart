
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AlbumEditDumb extends StatelessWidget {
  final String _title;
  final String _submitTitle;
  final VoidCallback? _onSubmit;
  final bool _isSubmitEnabled;
  final VoidCallback? _onDeleteCover;
  final VoidCallback? _onPickCover;
  final File? _cover;
  final TextEditingController? _nameController;

  const AlbumEditDumb({
    required this._nameController,
    this._isSubmitEnabled = false,
    this._onPickCover,
    this._onDeleteCover,
    this._onSubmit,
    this._submitTitle = '',
    this._title = '',
    this._cover,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        _title,
        style: const TextStyle(fontWeight: FontWeight.bold),
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
        FilledButton(
          onPressed: _isSubmitEnabled ? _onSubmit : null,
          child: Text(_submitTitle),
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
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _cover != null
                  ? Image.file(_cover, fit: BoxFit.cover)
                  : Column(
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
              ),
            ),
          ),
        ),
        if (_cover != null)
          TextButton.icon(
            onPressed: _onDeleteCover,
            // onPressed: () {
            // final newState = widget._handler.albumCreateRemoveCover(_state);
            // },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove Cover'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
      ],
    );
  }
}
