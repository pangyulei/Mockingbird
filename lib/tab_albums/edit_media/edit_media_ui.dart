import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/tab_albums/edit_media/edit_media_provider.dart';

class EditMediaUI extends ConsumerWidget {
  final int? _id;
  const EditMediaUI(this._id, {super.key});

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Text(
        'Rename Media',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final nameController = ref.watch(
                  editMediaProvider(_id).select((st) => st.nameController),
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
                      color: Theme.of(
                        ctx,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    hintText: 'Enter Album name',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    prefixIcon: Icon(
                      Icons.edit_note_rounded,
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Theme.of(ctx).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                  autofocus: true,
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _onCancel(ctx),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (ctx, ref, child) {
            final enable = ref.watch(
              editMediaProvider(_id).select((s) => s.enableSubmit),
            );
            const submitTitle = 'Save';
            if (enable) {
              return FilledButton(
                onPressed: () => _onSubmit(ctx, ref),
                child: const Text(submitTitle),
              );
            } else {
              return const FilledButton(
                onPressed: null,
                child: Text(submitTitle),
              );
            }
          },
        ),
      ],
    );
  }

  void _onNameChanged(WidgetRef ref, String newName) {
    ref.read(editMediaProvider(_id).notifier).updateName(newName);
  }

  void _onSubmit(BuildContext ctx, WidgetRef ref) async {
    await ref.read(editMediaProvider(_id).notifier).submit();
    if (ctx.mounted) {
      Navigator.of(ctx).pop();
    }
  }

  void _onCancel(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }
}
