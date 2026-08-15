import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_event.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumDetailBloc extends Bloc<AlbumDetailEvent, AlbumDetailState> {
  final String _id;
  AlbumDetailBloc(this._id)
    : super(const AlbumDetailLoadingState()) {
    on<AlbumDetailLoadingEvent>(_onLoading);
  }

  void _onLoading(
    AlbumDetailLoadingEvent event,
    Emitter<AlbumDetailState> emit,
  ) async {
    //TODO handle '' id
    final album = await AssetPathEntity.fromId(_id);
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
