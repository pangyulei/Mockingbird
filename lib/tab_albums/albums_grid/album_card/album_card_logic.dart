import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/albums_nav/albums_nav_route.dart';
import 'album_card_interface_ui_events.dart';
import 'album_card_state.dart';

class AlbumCardLogic implements AlbumCardInterfaceUIEvents {
  const AlbumCardLogic();

  @override
  AlbumCardState albumCardPressedStateChanged(
    AlbumCardState state,
    bool isPressed,
  ) {
    return state.copyWith(isPressed: isPressed);
  }

  @override
  void albumCardOnTap(BuildContext context, Album album) {
    Navigator.pushNamed(
      context,
      AlbumsNavRoute.urlStrForAlbumDetail(album.id),
    );
  }
}
