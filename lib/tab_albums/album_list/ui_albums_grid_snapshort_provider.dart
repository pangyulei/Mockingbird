


//   @override
//   bool albumsGridAcceptDragAndDrop(AlbumCardState drag, AlbumCardState drop) {
//     return _albums[drag.index].id != _albums[drop.index].id;
//   }

//   @override
//   void albumsGridDragAndDrop(AlbumCardState drag, AlbumCardState drop) async {
//     // await _swapAlbums(draggedAlbum, targetAlbum);
//   }

//   // Future<void> _swapAlbums(Album draggedAlbum, Album targetAlbum) async {
//   //   setState(() {
//   //     _showLoading = true;
//   //   });
//   //   int fromIndex = _albums.indexOf(draggedAlbum);
//   //   int toIndex = _albums.indexOf(targetAlbum);
//   //   //swap db sortorder first, then swap their place in List
//   //   (draggedAlbum, targetAlbum) = await DBAlbum(
//   //     DBObjectBox.instance.store,
//   //   ).swapSortOrder(draggedAlbum, targetAlbum);
//   //   setState(() {
//   //     _albums[fromIndex] = targetAlbum;
//   //     _albums[toIndex] = draggedAlbum;
//   //     _showLoading = false;
//   //   });
//   // }




//   // void _onTapAlbum(Album album) {
//   //   Navigator.pushNamed(context, RouteAlbums.albumDetail(album.id));
//   // }

