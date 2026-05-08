import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_events.dart';
import 'package:mockingbird/tab_playlist/playlists/playlist_create/playlist_create_state.dart';

class PlaylistCreateWidget extends StatefulWidget {
  final PlaylistCreateEvents _handler;
  const PlaylistCreateWidget(this._handler, {super.key});

  static Future<void> show(BuildContext context, PlaylistCreateEvents handler) async {
    await showDialog(
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
      final newState = widget._handler.playlistCreateWidgetTypingName(_state, nameController.text);
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
    return AlertDialog(
      title: const Text('Create New Playlist'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cover image preview and selection
          GestureDetector(
            onTap: () async {
              final XFile? xImage = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 512,
                maxHeight: 512,
                imageQuality: 75,
              );
              if (xImage != null) {
                File cover = File(xImage.path);
                final newState = widget._handler.playlistCreateWidgetSelectedCover(_state, cover);
                _updateState(newState);
              }
            },
            child: Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: _state.cover != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_state.cover!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to select cover image',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Playlist name input
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Playlist Name',
              hintText: 'Enter playlist name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.music_note),
            ),
            autofocus: true,
          ),
          Row(
            children: [
              Text(_state.alert, style: const TextStyle(color: Colors.red),),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            //cancel
            Navigator.of(context).pop(); //TODO make this pop with argumrnt cancel:true
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(disabledForegroundColor: Colors.grey[600]),
          onPressed: _state.creatable ? () async {
            //TODO should not block UI here
              await widget._handler.playlistCreateWidgetClickedCreate(_state, nameController.text);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
          } : null,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
