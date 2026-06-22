
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingbird/model/album.dart';

import 'album_card_dumb.dart';


class AlbumCard extends StatefulWidget {
  final VoidCallback? _onEdit;
  final VoidCallback? _onTap;
  final VoidCallback? _onDelete;
  final Album _album;

  const AlbumCard({
    required this._album,
    this._onEdit,
    this._onTap,
    this._onDelete,
    super.key
  });

  @override
  State<AlbumCard> createState() =>
      _State();
}

class _State extends State<AlbumCard> {
  var _isPressing = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) async {
        await HapticFeedback.heavyImpact();
        setState(() => _isPressing = true);
      },
      onTapUp: (_) => setState(() => _isPressing = false),
      onTapCancel: () => setState(() => _isPressing = false),
      onTap: widget._onTap,
      child: AnimatedScale(
        scale: _isPressing ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AlbumCardDumb(
          cover: widget._album.cover,
          mediasCount: widget._album.medias.length,
          name: widget._album.name,
          onDelete: widget._onDelete,
          onEdit: widget._onEdit,
        ),
      ),
    );
  }
}
