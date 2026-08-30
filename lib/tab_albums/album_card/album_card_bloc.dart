import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_event.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumCardBloc extends Bloc<AlbumCardEvent, AlbumCardState> {
  final AssetPathEntity _album;
  AlbumCardBloc(this._album) : super(const AlbumCardState.empty()) {
    on<AlbumCardInitEvent>(_onInit);
    on<AlbumCardClickEvent>(_onClick);
  }

  void _onClick(AlbumCardClickEvent event, Emitter<AlbumCardState> emit) {
    event.context.go(AppRoute.albumById(_album.id));
  }

  void _onInit(AlbumCardInitEvent event, Emitter<AlbumCardState> emit) async {
    final count = await _album.assetCountAsync;
    emit(AlbumCardState(mediaCount: count, name: _album.name));
  }
}
