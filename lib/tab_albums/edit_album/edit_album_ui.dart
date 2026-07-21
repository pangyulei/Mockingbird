import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';

class EditAlbumUI extends ConsumerWidget {
  final int? _id;

  const EditAlbumUI(this._id, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Consumer(
        builder: (context, ref, child) {
          final title = ref.watch(editAlbumProvider(_id).select((s) => s.title));
          return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
        },
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _cover(ctx),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final nameController = ref.watch(
                  editAlbumProvider(_id).select((st) => st.nameController),
                );
                //nameController.addListner
                return TextField(
                  onChanged: (newName) => _onNameChanged(ref, newName),
                  controller: nameController,
                  cursorColor: Theme.of(ctx).colorScheme.primary,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Album Name',
                    labelStyle: TextStyle(
                      color: Theme.of(ctx).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    hintText: 'Enter Album name',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                    prefixIcon: Icon(
                      Icons.edit_note_rounded,
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      ctx,
                    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  autofocus: true,
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => _onCancel(ctx), child: const Text('Cancel')),
        Consumer(
          builder: (ctx, ref, child) {
            final (enable, submitTitle) = ref.watch(
              editAlbumProvider(_id).select((s) => (s.enableSubmit, s.submitTitle)),
            );
            if (enable) {
              return FilledButton(onPressed: () => _onSubmit(ctx, ref), child: Text(submitTitle));
            } else {
              return FilledButton(onPressed: null, child: Text(submitTitle));
            }
          },
        ),
      ],
    );
  }

  Widget _cover(BuildContext ctx) {
    return Consumer(
      builder: (ctx, ref, child) {
        final cover = ref.watch(editAlbumProvider(_id).select((s) => s.cover));
        return Stack(
          children: [
            GestureDetector(
              onTap: () => _onPickCover(ref),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: cover != null ? Image.file(cover, fit: BoxFit.cover) : _noImage(ctx),
                ),
              ),
            ),
            if (cover != null) Positioned(top: 8, right: 8, child: _removeCoverButton(ctx, ref)),
          ],
        );
      },
    );
  }

  Widget _removeCoverButton(BuildContext ctx, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onRemoveCover(ref),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 20,
            color: Theme.of(ctx).colorScheme.error,
          ),
        ),
      ),
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

  void _onPickCover(WidgetRef ref) async {
    await ref.read(editAlbumProvider(_id).notifier).pickCover();
  }

  void _onNameChanged(WidgetRef ref, String newName) {
    ref.read(editAlbumProvider(_id).notifier).updateName(newName);
  }

  void _onRemoveCover(WidgetRef ref) {
    ref.read(editAlbumProvider(_id).notifier).removeCover();
  }

  void _onSubmit(BuildContext ctx, WidgetRef ref) async {
    await ref.read(editAlbumProvider(_id).notifier).submit();
    if (ctx.mounted) {
      Navigator.of(ctx).pop();
    }
  }

  void _onCancel(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }
}
