import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_state.dart';
import 'package:mockingbird/tab_albums/edit_album/edit_album_ui.dart';

class EditAlbumScreen extends StatefulWidget {
  final Album? _album;

  const EditAlbumScreen(this._album, {super.key});

  @override
  State<EditAlbumScreen> createState() => _EditAlbumScreenState();
}

class _EditAlbumScreenState extends State<EditAlbumScreen>
    implements EditAlbumUIOutputITF {
  var _state = const EditAlbumState.empty();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget._album != null) {
      Album album = widget._album!;
      File? cover = album.cover == null ? null : File(album.cover!);
      _nameController.text = album.name;
      _state = _state.copyWith(
        title: 'Edit Album',
        submitTitle: 'Save',
        cover: () => cover,
        enableSubmit: false,
      );
    } else {
      _nameController.text = '';
      _state = _state.copyWith(
        title: 'Create New Album',
        submitTitle: 'Create',
        cover: () => null,
        enableSubmit: false,
      );
    }
    _nameController.addListener(() {
      // final trimmedName = _nameController.text.trim();
      // if (_nameController.text != trimmedName) {
      //   _nameController.text = trimmedName;
      // }
      final enableSubmit = _isSubmitEnable(
        _nameController.text,
        _state.cover,
        widget._album,
      );
      if (_state.enableSubmit != enableSubmit) {
        setState(() {
          _state = _state.copyWith(enableSubmit: enableSubmit);
        });
      }
    });
  }

  bool _isSubmitEnable(String name, File? cover, Album? album) {
    if (album == null) {
      //is creating, only valid name
      return name.trim().isNotEmpty;
    } else {
      //is editing, name or cover is different then able to update
      if (name.trim() != album.name) return true;
      if (cover?.path != album.cover) return true;
      return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditAlbumUI(_state, _nameController, this);
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
    setState(() {
      _state = _state.copyWith(
        cover: () => newCover,
        enableSubmit: _isSubmitEnable(
          _nameController.text,
          newCover,
          widget._album,
        ),
      );
    });
  }

  @override
  void editAlbum_onRemoveCover() {
    File? newCover;
    setState(() {
      _state = _state.copyWith(
        cover: () => newCover,
        enableSubmit: _isSubmitEnable(
          _nameController.text,
          newCover,
          widget._album,
        ),
      );
    });
  }

  @override
  void editAlbum_onSubmit() async {
    final dbAlbum = DBAlbum(DBObjectBox().store);
    final Album? album = widget._album;
    setState(() {
      _state = _state.copyWith(showLoading: true);
    });
    if (album == null) {
      //creating
      await dbAlbum.create(name: _nameController.text, cover: _state.cover);
    } else {
      //editing
      await dbAlbum.update(album, _nameController.text, _state.cover);
    }
    setState(() {
      _state = _state.copyWith(showLoading: false);
    });
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
