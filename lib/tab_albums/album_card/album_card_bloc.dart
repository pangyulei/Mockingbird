import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_event.dart';
import 'package:mockingbird/tab_albums/album_card/album_card_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumCardBloc extends Bloc<AlbumCardEvent, AlbumCardState> {
  final String _id;
  AlbumCardBloc(this._id) : super(const AlbumCardState.empty()) {
    on<AlbumCardLoadingEvent>(_onLoading);
    on<AlbumCardClickEvent>(_onClick);
  }

  void _onClick(AlbumCardClickEvent event, Emitter<AlbumCardState> emit) {
    event.context.go(AppRoute.albumDetail(_id));
  }

  void _onLoading(
    AlbumCardLoadingEvent event,
    Emitter<AlbumCardState> emit,
  ) async {
    final album = await AssetPathEntity.fromId(_id);
    final count = await album.assetCountAsync;
    emit(AlbumCardState(mediaCount: count, name: album.name));
  }
}
