import 'package:flutter/material.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';

sealed class AlbumsGridState {
  const AlbumsGridState();
}

class AlbumsGridStateGeneral extends AlbumsGridState {
  final bool showLoading;
  final int albumsCount;
  final List<AlbumCardState> albumStates;
  const AlbumsGridStateGeneral({
    required this.showLoading,
    required this.albumStates,
    required this.albumsCount,
  });
  AlbumsGridStateGeneral copyWith({
    bool? showLoading,
    int? albumsCount,
    List<AlbumCardState>? albumStates,
  }) {
    return AlbumsGridStateGeneral(
      showLoading: showLoading ?? this.showLoading,
      albumStates: albumStates ?? this.albumStates,
      albumsCount: albumsCount ?? this.albumsCount,
    );
  }
}

class AlbumsGridStateCreatingAlbum extends AlbumsGridState {
  const AlbumsGridStateCreatingAlbum();
}

class AlbumsGridStateEditingAlbum extends AlbumsGridState {
  final Album album;
  const AlbumsGridStateEditingAlbum(this.album);
}
