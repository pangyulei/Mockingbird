import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/models/playlist.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateWidget extends StatefulWidget {
  final PlaylistCreateEvents _handler;
  const PlaylistCreateWidget(this._handler, {super.key});

  static Future<Playlist?> show(
    BuildContext context,
    PlaylistCreateEvents handler,
  ) async {
    return await showDialog<Playlist?>(
      context: context,
      builder: (BuildContext context) {
        return PlaylistCreateWidget(handler);
      },
    );
  }

  @override
  State<PlaylistCreateWidget> createState() => _PlaylistCreateWidgetFactory();
}

class _PlaylistCreateWidgetFactory extends State<PlaylistCreateWidget> {
  PlaylistCreateState _state = const PlaylistCreateState();
  final TextEditingController nameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Rebuilds the UI every time the text changes so the "Create" button updates
    nameController.addListener(() {
      final newState = widget._handler.playlistCreateWidgetTypingName(
        _state,
        nameController.text,
      );
      _updateState(newState);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateState(PlaylistCreateState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF1E1F23);
    const lightShadow = Color(0xFF2A2B31);
    const darkShadow = Color(0xFF121216);

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Text(
        'Create New Playlist',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCoverWidget(bgColor, lightShadow, darkShadow),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFFF4D00),
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
                labelStyle: TextStyle(color: Color(0xFF6A6C75)),
                hintText: 'Enter playlist name',
                hintStyle: TextStyle(color: Color(0xFF444549)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2A2B31)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF4D00)),
                ),
                prefixIcon: Icon(Icons.playlist_play, color: Color(0xFFFF4D00)),
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF6A6C75)),
          ),
        ),
        GestureDetector(
          onTap: _state.creatable ? _clickedCreate : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: _state.creatable
                  ? const LinearGradient(
                      colors: [Color(0xFFFF4D00), Color(0xFFE63E00)],
                    )
                  : null,
              color: _state.creatable ? null : const Color(0xFF2A2B31),
              boxShadow: _state.creatable
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF4D00).withValues(alpha: 0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              'CREATE',
              style: TextStyle(
                color: _state.creatable
                    ? Colors.white
                    : const Color(0xFF444549),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clickedCover() async {
    final XFile? xImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    if (xImage != null) {
      File cover = File(xImage.path);
      final newState = widget._handler.playlistCreateWidgetSelectedCover(
        _state,
        cover,
      );
      _updateState(newState);
    }
  }

  Widget _buildCoverWidget(Color bgColor, Color lightShadow, Color darkShadow) {
    return GestureDetector(
      onTapDown: (_) => _updateState(_state.copyWith(isCoverPressed: true)),
      onTapUp: (_) => _updateState(_state.copyWith(isCoverPressed: false)),
      onTapCancel: () => _updateState(_state.copyWith(isCoverPressed: false)),
      onTap: _clickedCover,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          gradient: _state.isCoverPressed
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [darkShadow, lightShadow],
                )
              : null,
          boxShadow: _state.isCoverPressed
              ? []
              : [
                  BoxShadow(
                    color: darkShadow,
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: lightShadow,
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _state.cover != null
              ? Image.file(_state.cover!, fit: BoxFit.cover)
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Color(0xFF6A6C75),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select Cover',
                      style: TextStyle(color: Color(0xFF6A6C75), fontSize: 14),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _clickedCreate() async {
    final newPlaylist = await widget._handler.playlistCreateWidgetClickedCreate(
      _state,
      nameController.text,
    );
    Navigator.of(context).pop(newPlaylist);
  }
}
