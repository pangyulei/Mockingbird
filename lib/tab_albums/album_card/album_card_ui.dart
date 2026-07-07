import 'dart:io';
import 'package:flutter/material.dart';
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



class AlbumCardUI extends StatelessWidget {
  final AlbumCardUIOutputITF _logic;
  final AlbumCardState _state;
  final int _index;
  const AlbumCardUI(this._index, this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => _logic.albumCard_onTap(_index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(child: _cover(context)),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(top: 8, right: 8, child: _menu(context)),
                  ],
                ),
              ),
            ),
          ),
          // Name and song count below cover
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _state.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_state.mediasCount} Medias',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
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

  Widget _menu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 20, color: Colors.white),
      onSelected: (value) {
        if (value == _MoreItem.edit.raw) {
          _logic.albumCard_onEdit(_index);
        } else if (value == _MoreItem.delete.raw) {
          _logic.albumCard_onDelete(_index);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MoreItem.edit.raw,
          child: const Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 12),
              Text('Edit Album'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MoreItem.delete.raw,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ),
        ),
      ],
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _cover(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String? cover = _state.cover;
    if (cover != null) {
      return Image.file(File(cover), fit: BoxFit.cover);
    } else {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.album_rounded,
            color: colorScheme.primary.withValues(alpha: 0.5),
            size: 48,
          ),
        ),
      );
    }
  }
}
