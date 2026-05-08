import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlaylistCreateWidget extends StatefulWidget {
  const PlaylistCreateWidget({super.key});

  @override
  State<PlaylistCreateWidget> createState() => _PlaylistCreateWidgetFactory();
}

class _PlaylistCreateWidgetFactory extends State<PlaylistCreateWidget> {
  final TextEditingController nameController = TextEditingController();
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Playlist'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cover image preview and selection
            GestureDetector(
              onTap: () async {
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 512,
                  maxHeight: 512,
                  imageQuality: 75,
                );
                if (image != null) {
                  setState(() {
                    selectedImage = File(image.path);
                  });
                }
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            //cancel
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.trim().isNotEmpty) {
              print(nameController.text.trim());
              print(selectedImage);
              // setState(() {
              //   _playlists.insert(
              //     0,
              //     _PlaylistData(
              //       title: nameController.text.trim(),
              //       coverImage: selectedImage,
              //     ),
              //   );
              // });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
