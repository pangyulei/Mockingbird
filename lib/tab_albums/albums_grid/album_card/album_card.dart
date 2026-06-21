import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/albums_grid/album_card/album_card_dumb.dart';
import 'package:mockingbird/tab_albums/albums_nav/albums_nav_route.dart';


class AlbumCard extends StatefulWidget {
  final VoidCallback? _onEdit;
  final VoidCallback? _onDelete;
  final Album _album;
  final bool _showEditButtons;

  const AlbumCard({
    required this._album,
    this._onEdit,
    this._onDelete,
    this._showEditButtons = false,
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
      onTap: () {
        Navigator.pushNamed(context, AlbumsNavRoute.urlStrForAlbumDetail(widget._album.id));
      },
      child: AnimatedScale(
        scale: _isPressing ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AlbumCardDumb(
          cover: widget._album.cover,
          mediasCount: widget._album.medias.length,
          name: widget._album.name,
          onDelete: widget._onDelete,
          onEdit: widget._onEdit,
          showEditButtons: widget._showEditButtons,
        ),
      ),
    );
  }
}
