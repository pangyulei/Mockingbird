import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';
import 'album_card_state.dart';

enum _MoreItem {
  delete('delete'),
  edit('edit');

  final String raw;
  const _MoreItem(this.raw);
}

abstract interface class AlbumCardUIOutputITF {
  void albumCard_onTap(int index);
  void albumCard_onEdit(int index);
  void albumCard_onDelete(int index);
}


abstract interface class AlbumCardLogicITF implements AlbumCardUIOutputITF {

}

class AlbumCardUI extends StatefulWidget {
  final AlbumCardLogicITF _logic;
  final AlbumCardState _state;
  const AlbumCardUI({required this._logic, required this._state, super.key});

  @override
  State<StatefulWidget> createState() => _AlbumCardUIState();
}

class _AlbumCardUIState extends State<AlbumCardUI> {

  @override
  Widget build(BuildContext context) {
    AlbumCardState state = widget._state;
    AlbumCardLogicITF logic = widget._logic;
    return InkWell(
      onTap: () => logic.albumCard_onTap(state.index),
      child: Column(
        children: [
          // Cover image area
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              elevation: 2, //widget._state.isPressed ? 1 : 2,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(child: _cover()),
                    Positioned(top: 4, right: 4, child: _menu()),
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
                  state.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF191C1E),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${state.mediasCount} Medias',
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
    );
  }

  Widget _menu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (value) {
        if (value == _MoreItem.edit.raw) {
          widget._logic.albumCard_onEdit(widget._state.index);
        } else if (value == _MoreItem.delete.raw) {
          widget._logic.albumCard_onDelete(widget._state.index);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreItem.edit.raw,
          child: const Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MoreItem.delete.raw,
          child: const Row(
            children: [
              Icon(Icons.delete, size: 18),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        minimumSize: const Size(28, 28),
        padding: EdgeInsets.zero,
        tapTargetSize: .shrinkWrap,
      ),
    );
  }

  Widget _cover() {
    String? cover = widget._state.cover;
    if (cover != null) {
      return Opacity(
        opacity: 1, //widget._state.isPressed ? 0.7 : 1.0,
        child: Image.file(File(cover), fit: BoxFit.cover),
      );
    } else {
      return Center(
        child: Icon(
          Icons.video_library_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
      );
    }
  }

  @override
  void handleNewState(AlbumCardState newState) {
   
  }
}
