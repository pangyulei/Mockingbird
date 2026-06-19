import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'album_card_state.dart';

abstract interface class AlbumCardInterfaceUIEvents {
  AlbumCardState albumCardPressedStateChanged(
    AlbumCardState state,
    bool isPressed,
  );
  void albumCardOnTap(BuildContext context, Album album);
}
