
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumCardDumb extends StatelessWidget {
  final VoidCallback? _onEdit;
  final VoidCallback? _onDelete;
  final String? _cover;
  final int _mediasCount;
  final String _name;

  const AlbumCardDumb({
    super.key,
    required this._onEdit,
    required this._onDelete,
    required this._cover,
    required this._mediasCount,
    required this._name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cover image area
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,//widget._state.isPressed ? 1 : 2,
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
                  if (_cover != null)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 1,//widget._state.isPressed ? 0.7 : 1.0,
                        child: Image.file(
                          File(_cover),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (_cover == null)
                    Center(
                      child: Icon(
                        Icons.video_library_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Column(
                      spacing: 2,
                      children: [
                        IconButton.filledTonal(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: _onEdit,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                            tapTargetSize: .shrinkWrap,
                          ),
                        ),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: _onDelete,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                            tapTargetSize: .shrinkWrap,
                          ),
                        ),
                      ],
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
                _name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF191C1E),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '$_mediasCount Medias',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF42474E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}