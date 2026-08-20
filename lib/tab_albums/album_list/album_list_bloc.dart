import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_event.dart';
import 'package:mockingbird/tab_albums/album_list/album_list_state.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  AlbumListBloc() : super(const AlbumListInitState()) {
    on<AlbumListInitEvent>(_onInit);
    on<AlbumListRequestPermissionEvent>(_onRequestPermission);
  }

  void _onInit(AlbumListInitEvent event, Emitter<AlbumListState> emit) async {
    emit(await _reload());
  }

  Future<AlbumListState> _reload() async {
    final metadata = await DB.loadMetadata();
    if (!metadata.permissionRequested) {
      return const AlbumListNotYetRequestedState();
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
      return const AlbumListPermissionDeniedState();
    }
    final albumList = await PhotoManager.getAssetPathList(
      type: RequestType.audio | RequestType.video,
    );
    if (albumList.isEmpty) {
      return const AlbumListEmptyState();
    }
    return AlbumListDataState(albumIdList: albumList.map((a) => a.id).toList());
  }

  void _onRequestPermission(
    AlbumListRequestPermissionEvent event,
    Emitter<AlbumListState> emit,
  ) async {
    await PhotoManager.requestPermissionExtend();
    emit(state.copyWith(loading: true));
    emit(await _reload());
  }
}

extension on PermissionState {
  bool get granted =>
      {PermissionState.limited, PermissionState.authorized}.contains(this);
}
