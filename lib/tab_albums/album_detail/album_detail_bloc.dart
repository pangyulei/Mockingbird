import 'package:defer/defer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_event.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_bloc.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_event.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumDetailBloc extends AlbumDetailBlocType {
  final String? _albumId;
  AlbumDetailBloc(this._albumId) : super(const AlbumDetailInitState()) {
    on<AlbumDetailInitEvent>(_onInit);
  }

  @override
  Future<void> close() {
    debugPrint('albumdetail close');
    return super.close();
  }

  void _onInit(
    AlbumDetailInitEvent event,
    Emitter<AlbumDetailState> emit,
  ) async {
    EasyLoading.show(maskType: .clear);
    await defer(
      () async {
        EasyLoading.dismiss();
      },
      () async {
        if (_albumId == null) {
          emit(const AlbumDetailNotFoundState());
          return;
        }
        final album = await AssetPathEntity.fromId(_albumId);
        final mediaList = await album.getAssetListRange(
          start: 0,
          end: await album.assetCountAsync,
        );
        // Sort by title ascending (case-insensitive)
        mediaList.sort((a, b) {
          final aTitle = a.title?.toLowerCase() ?? '';
          final bTitle = b.title?.toLowerCase() ?? '';
          return aTitle.compareTo(bTitle);
        });
        emit(AlbumDetailDataState(name: album.name, mediaList: mediaList));
        emit(AlbumDetailDataState(name: album.name, mediaList: mediaList));
      },
    );
  }

  @override
  MediaCardBlocType mediaCardBlocAtIndex(int index) {
    final media = state.as<AlbumDetailDataState>()?.mediaList[index];
    return MediaCardBloc(media)..add(const MediaCardInitEvent());
  }
}
