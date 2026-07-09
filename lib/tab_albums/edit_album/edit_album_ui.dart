import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';

abstract interface class EditAlbumUIOutputITF {
  void editAlbum_onSubmit();
  void editAlbum_onCancel();
  void editAlbum_onPickCover();
  void editAlbum_onRemoveCover();
}

class EditAlbumUI extends ConsumerWidget {
  // final EditAlbumState _state;
  final TextEditingController _nameController;
  final EditAlbumUIOutputITF _logic;
  final int? _id;
  const EditAlbumUI(
    // this._state,
    this._id,
    this._nameController,
    this._logic, {
    super.key,
  });

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    ref.listen(
      editAlbumProvider(_id).select((s) => s.name),
      (previous, next) => _nameController.text = next,
    );
    final isLoading = ref.watch(editAlbumAsyncProvider(_id)).isLoading;
    return Stack(children: [_dialog(ctx), if (isLoading) _loading()]);
  }

  Widget _dialog(BuildContext ctx) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Consumer(
        builder: (context, ref, child) {
          final title = ref.watch(
            editAlbumProvider(_id).select((s) => s.title),
          );
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
          onPressed: _logic.editAlbum_onCancel,
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, child) {
            final (enable, submitTitle) = ref.watch(
              editAlbumProvider(
                _id,
              ).select((s) => (s.enableSubmit, s.submitTitle)),
            );
            return FilledButton(
              onPressed: enable ? _logic.editAlbum_onSubmit : null,

              child: Text(submitTitle),
            );
          },
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
          onTap: _logic.editAlbum_onPickCover,
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
            child: Consumer(
              builder: (context, ref, child) {
                final cover = ref.watch(
                  editAlbumProvider(_id).select((s) => s.cover),
                );
                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: cover != null
                      ? Image.file(cover, fit: BoxFit.cover)
                      : _noImage(ctx),
                );
              },
            ),
          ),
        ),
        Consumer(
          builder: (ctx, ref, child) {
            final cover = ref.watch(
              editAlbumProvider(_id).select((s) => s.cover),
            );
            return cover != null ? _removeButton(ctx) : const SizedBox.square();
          },
        ),
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
      onPressed: _logic.editAlbum_onRemoveCover,
      icon: const Icon(Icons.delete_outline, size: 18),
      label: const Text('Remove Cover'),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(ctx).colorScheme.error,
      ),
    );
  }
}
