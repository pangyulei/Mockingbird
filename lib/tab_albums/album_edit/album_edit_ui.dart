import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_edit/album_edit_state.dart';

abstract interface class AlbumEditUIOutputITF {
  void albumEdit_onSubmit();
  void albumEdit_onCancel();
  void albumEdit_onPickCover();
  void albumEdit_onRemoveCover();
}

class AlbumEditUI extends StatelessWidget {
  final AlbumEditState _state;
  final TextEditingController _nameController;
  final AlbumEditUIOutputITF _logic;
  const AlbumEditUI(
    this._state,
    this._nameController,
    this._logic, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_dialog(ctx), if (_state.showLoading) _loading()]);
  }

  Widget _dialog(BuildContext ctx) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        _state.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cover(ctx),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              cursorColor: Theme.of(ctx).colorScheme.primary,
              decoration: InputDecoration(
                labelText: 'Album Name',
                hintText: 'Enter Album name',
                prefixIcon: Icon(
                  Icons.playlist_play,
                  color: Theme.of(ctx).colorScheme.primary,
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _logic.albumEdit_onCancel,
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _state.enableSubmit ? _logic.albumEdit_onSubmit : null,

          child: Text(_state.submitTitle),
        ),
      ],
    );
  }

  Widget _cover(BuildContext ctx) {
    return Column(
      children: [
        GestureDetector(
          // onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
          // onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
          // onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
          onTap: _logic.albumEdit_onPickCover,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(
                ctx,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(ctx).colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _state.cover != null
                  ? Image.file(_state.cover!, fit: BoxFit.cover)
                  : _noImage(ctx),
            ),
          ),
        ),
        if (_state.cover != null) _removeButton(ctx),
      ],
    );
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _noImage(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: Theme.of(ctx).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Select Cover Image',
          style: TextStyle(
            color: Theme.of(ctx).colorScheme.primary,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _removeButton(BuildContext ctx) {
    return TextButton.icon(
      onPressed: _logic.albumEdit_onRemoveCover,
      icon: const Icon(Icons.delete_outline, size: 18),
      label: const Text('Remove Cover'),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(ctx).colorScheme.error,
      ),
    );
  }
}
