import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_provider.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';

class EditAlbumScreen extends ConsumerStatefulWidget {
  final int? _id;

  const EditAlbumScreen(this._id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAlbumScreenState();
}

class _EditAlbumScreenState extends ConsumerState<EditAlbumScreen>
    implements EditAlbumUIOutputITF {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      ref.read(editAlbumProvider(widget._id).notifier).onNameChanged(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditAlbumUI(widget._id, _nameController, this);
  }

  @override
  void editAlbum_onPickCover() async {
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage == null) {
      //didnt select any image, no changes
      return;
    }
    File newCover = File(xImage.path);
    ref.read(editAlbumProvider(widget._id).notifier).onCoverChanged(newCover);
  }

  @override
  void editAlbum_onRemoveCover() {
    ref.read(editAlbumProvider(widget._id).notifier).onCoverChanged(null);
  }

  @override
  void editAlbum_onSubmit() async {
    await ref.read(editAlbumAsyncProvider(widget._id).notifier).onSubmit();
    _pop();
  }

  @override
  void editAlbum_onCancel() {
    _pop();
  }

  void _pop() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
