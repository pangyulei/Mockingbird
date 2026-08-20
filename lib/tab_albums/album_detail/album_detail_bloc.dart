import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_event.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final String? _albumId;
  AlbumDetailBloc(this._albumId) : super(const AlbumDetailInitState()) {
    on<AlbumDetailInitEvent>(_onInit);
  }

  void _onInit(
    AlbumDetailInitEvent event,
    Emitter<AlbumDetailState> emit,
  ) async {
    if (_albumId == null) {
      emit(const AlbumDetailNotFoundState());
      return;
    }
    //TODO handle '' id, try-catch?
    final album = await AssetPathEntity.fromId(_albumId);
    final mediaList = await album.getAssetListRange(
      start: 0,
      end: await album.assetCountAsync,
    );
    emit(
      AlbumDetailDataState(
        name: album.name,
        mediaIdList: mediaList.map((a) => a.id).toList(),
      ),
    );
  }
}
