import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'album_card_interface_ui_events.dart';
import 'album_card_state.dart';

class AlbumCardWidget extends StatefulWidget {
  final Album _album;
  final AlbumCardInterfaceUIEvents _logic;
  const AlbumCardWidget(this._album, this._logic, {super.key});

  @override
  State<AlbumCardWidget> createState() =>
      _WidgetFactory();
}

class _WidgetFactory extends State<AlbumCardWidget> {
  late AlbumCardState _state;

  @override
  void initState() {
    super.initState();
    _state = AlbumCardState(album: widget._album);
  }

  void _updateState(AlbumCardState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateState(
        widget._logic.albumCardPressedStateChanged(_state, true),
      ),
      onTapUp: (_) {
        _updateState(
          widget._logic.albumCardPressedStateChanged(_state, false),
        );
        widget._logic.albumCardOnTap(context, widget._album);
      },
      onTapCancel: () => _updateState(
        widget._logic.albumCardPressedStateChanged(_state, false),
      ),
      child: AnimatedScale(
        scale: _state.isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            // Cover image area
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8),
                elevation: _state.isPressed ? 1 : 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      if (widget._album.cover != null)
                        Positioned.fill(
                          child: Opacity(
                            opacity: _state.isPressed ? 0.7 : 1.0,
                            child: Image.file(
                              File(widget._album.cover!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget._album.cover == null)
                        Center(
                          child: Icon(
                            Icons.video_library_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Name and song count below cover
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._album.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF191C1E),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_state.album.medias.length} Medias',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF42474E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
