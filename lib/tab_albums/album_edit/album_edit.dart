import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'album_edit_dumb.dart';

class AlbumEdit extends StatefulWidget {
  final void Function(String name, File? cover)? _onSubmit;
  final String _title;
  final File? _cover;
  final String _name;
  final String _submitTitle;

  const AlbumEdit({
    this._submitTitle = '',
    this._title = '',
    this._name = '',
    this._cover,
    this._onSubmit,
    super.key,
  });
  //
  // static Future<({String name, File? coverFile})?> show(
  //   BuildContext context,
  //   AlbumCreateInterfaceUIEvents logic, {
  //   String? initialName,
  //   File? initialCover,
  // }) async {
  //   return await showDialog<({String name, File? coverFile})?>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlbumEdit(
  //         logic,
  //         initialName: initialName,
  //         initialCover: initialCover,
  //       );
  //     },
  //   );
  // }

  @override
  State<AlbumEdit> createState() => _State();
}

class _State extends State<AlbumEdit> {
  late final TextEditingController _nameController;
  bool _isSubmitEnabled = false;
  File? _cover;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cover = widget._cover;
    _nameController = TextEditingController(text: widget._name);
    _nameController.addListener(() {
      setState(() {
        _isSubmitEnabled = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlbumEditDumb(
      nameController: _nameController,
      cover: _cover,
      isSubmitEnabled: _isSubmitEnabled,
      onDeleteCover: _onDeleteCover,
      onPickCover: _onPickCover,
      onSubmit: () {
        widget._onSubmit?.call(_nameController.text, _cover);
        Navigator.of(context).pop();
      },
      submitTitle: widget._submitTitle,//_isCreating ? 'Create' : 'Save',
      title: widget._title,//_isCreating ? 'Create New Album' : 'Edit Album',
    );
  }

  Future<void> _onPickCover() async {
    final XFile? xImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage != null) {
      setState(() {
        _cover = File(xImage.path);
      });
    }
  }

  void _onDeleteCover() {
    setState(() {
      _cover = null;
    });
  }

}
