import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class EditAlbumNotifierITF {
  Future<void> pickCover();
  void removeCover();
  void updateName(String newName);
  Future<void> submit();
}

class EditAlbumUI extends ConsumerStatefulWidget {
  final ProviderListenable<EditAlbumState> _provider;
  final EditAlbumNotifierITF _notifier;

  const EditAlbumUI(this._provider, this._notifier, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditAlbumUIState();
}

class _EditAlbumUIState extends ConsumerState<EditAlbumUI> {
  EditAlbumNotifierITF get _notifier => widget._notifier;

  ProviderListenable<EditAlbumState> get _provider => widget._provider;

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_dialog(ctx)]);
  }

  Widget _dialog(BuildContext ctx) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Consumer(
        builder: (context, ref, child) {
          final title = ref.watch(_provider.select((s) => s.title));
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
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final nameController = ref.watch(
                  _provider.select((st) => st.nameController),
                );
                return TextField(
                  onChanged: _onNameChanged,
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
        TextButton(onPressed: _onCancel, child: const Text('Cancel')),
        Consumer(
          builder: (context, ref, child) {
            final (enable, submitTitle) = ref.watch(
              _provider.select((s) => (s.enableSubmit, s.submitTitle)),
            );
            return FilledButton(
              onPressed: enable ? _onSubmit : null,
              child: Text(submitTitle),
            );
          },
        ),
      ],
    );
  }

  Widget _cover(BuildContext ctx) {
    return Consumer(
      builder: (ctx, ref, child) {
        final cover = ref.watch(_provider.select((s) => s.cover));
        return Stack(
          children: [
            GestureDetector(
              onTap: _onPickCover,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Theme.of(
                    ctx,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: cover != null
                      ? Image.file(cover, fit: BoxFit.cover)
                      : _noImage(ctx),
                ),
              ),
            ),
            if (cover != null)
              Positioned(top: 8, right: 8, child: _removeCoverButton(ctx)),
          ],
        );
      },
    );
  }

  Widget _removeCoverButton(BuildContext ctx) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onRemoveCover,
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

  void _onPickCover() async {
    await _notifier.pickCover();
  }

  void _onNameChanged(String newName) {
    _notifier.updateName(newName);
  }

  void _onRemoveCover() {
    _notifier.removeCover();
  }

  void _onSubmit() async {
    await _notifier.submit();
    _pop();
  }

  void _onCancel() {
    _pop();
  }

  void _pop() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
