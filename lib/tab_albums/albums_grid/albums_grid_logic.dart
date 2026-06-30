import 'dart:async';

import 'package:mockingbird/db/db_album.dart';
import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_state.dart';
import 'package:mockingbird/tab_albums/albums_grid/albums_grid_ui.dart';

class AlbumsGridLogic implements AlbumsGridLogicITF {
  AlbumsGridUIInputITF? _output;
  var _albums = <Album>[];
  final _subs = <StreamSubscription>[];

  @override
  void albumsGrid_initState() async {
    // await Future.delayed(const Duration(seconds: 3));
    _output?.handleNewState(
      const AlbumsGridStateGeneral(
        showLoading: true,
        albumStates: [],
        albumsCount: 0,
      ),
    );
    //observe Album DB
    final albumsStream = DBObjectBox().store
        .box<Album>()
        .query()
        .watch(triggerImmediately: true)
        .map((q) => q.find());
    final sub = albumsStream.listen((albums) {
      _albums = albums;
      final albumStates = _albums.map((a) {
        return AlbumCardState(
          index: 0,
          mediasCount: a.medias.length,
          name: a.name,
          cover: a.cover,
        );
      }).toList();
      _output?.handleNewState(
        AlbumsGridStateGeneral(
          albumStates: albumStates,
          albumsCount: _albums.length,
          showLoading: false,
        ),
      );
    });
    _subs.add(sub);
  }

  @override
  set output(AlbumsGridUIInputITF output) {
    _output = output;
  }

  @override
  void albumsGrid_onAddAlbum() {
    _output?.handleNewState(const AlbumsGridStateCreatingAlbum());
  }

  @override
  void albumsGrid_dispose() {
    _cancelAllSubs();
  }

  void _cancelAllSubs() {
    for (final sub in _subs) {
      sub.cancel();
    }
  }

  @override
  void albumsGrid_onDeleteAlbum(AlbumsGridStateGeneral state, int index) async {
    _output?.handleNewState(state.copyWith(showLoading: true));
    Album album = _albums[index];
    await DBAlbum(DBObjectBox().store).remove(album);
  }

  @override
  void albumsGrid_onEditAlbum(int index) {
    Album album = _albums[index];
    _output?.handleNewState(AlbumsGridStateEditingAlbum(album));
  }

  @override
  void albumsGrid_onTapAlbum(int index) {
    // TODO: implement albumsGrid_onTapAlbum
  }
}
