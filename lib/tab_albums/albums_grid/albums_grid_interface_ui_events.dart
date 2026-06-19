import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'albums_grid_state.dart';

abstract interface class AlbumsGridInterfaceUIEvents {
  Stream<AlbumsGridState> albumsGridInitState();
  bool dragTargetWillAccept(
    AlbumsGridState state,
    Album targetAlbum,
    Album draggedAlbum,
  );
  Stream<AlbumsGridState> albumsGridDragTargetAccepted(
    AlbumsGridState state,
    Album targetAlbum,
    Album draggedAlbum,
  );
  Stream<AlbumsGridState> albumsGridPoppedCreateWidget(
    AlbumsGridState state,
    ({String name, File? coverFile})? newAlbumInfo,
  );
  AlbumsGridState albumsGridToggleSelectionMode(AlbumsGridState state);
  AlbumsGridState albumsGridToggleAlbumSelection(
    AlbumsGridState state,
    int albumId,
  );
  Stream<AlbumsGridState> albumsGridBatchRemoveSelected(
    AlbumsGridState state,
  );
}
