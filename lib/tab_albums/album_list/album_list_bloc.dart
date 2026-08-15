import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/db/db_logic.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_event.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  AlbumListBloc() : super(const AlbumListLoadingState()) {
    on<AlbumListLoadingEvent>(_onLoading);
    on<AlbumListRequestPermissionEvent>(_onRequestPermission);
  }

  void _onLoading(
    AlbumListLoadingEvent event,
    Emitter<AlbumListState> emit,
  ) async {
    final metadata = await DBLogic().loadMetadata();
    if (!metadata.permissionRequested) {
      emit(const AlbumListNotYetRequestedState());
      return;
    }
    //mediaLocation is for media's GPS info, I dont need that.
    //first time state is denied, only allow selected, is limited, allow-all is limited
    final option = PermissionRequestOption(
      androidPermission: AndroidPermission(
        type: RequestType.video | RequestType.audio,
        mediaLocation: false,
      ),
    );
    PermissionState permissionState = await PhotoManager.getPermissionState(
      requestOption: option,
    );
    if (!permissionState.granted) {
      emit(const AlbumListPermissionDeniedState());
      return;
    }
    final albumList = await PhotoManager.getAssetPathList(
      type: RequestType.audio | RequestType.video,
    );
    if (albumList.isEmpty) {
      emit(const AlbumListEmptyState());
      return;
    }
    emit(AlbumListDataState(albumIdList: albumList.map((a) => a.id).toList()));
  }

  void _onRequestPermission(
    AlbumListRequestPermissionEvent event,
    Emitter<AlbumListState> emit,
  ) async {
    await PhotoManager.requestPermissionExtend();
    emit(const AlbumListLoadingState());
    _onLoading(const AlbumListLoadingEvent(), emit);
  }
}

extension on PermissionState {
  bool get granted =>
      {PermissionState.limited, PermissionState.authorized}.contains(this);
}
