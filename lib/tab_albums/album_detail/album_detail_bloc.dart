import 'dart:async';

import 'package:defer/defer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_event.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_ui.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_bloc.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_event.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:mockingbird/tool/extensions.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumDetailBloc extends AlbumDetailBlocType {
  final String? _albumId;
  final _subscriptionList = <StreamSubscription>[];

  AlbumDetailBloc(this._albumId) : super(const AlbumDetailInitState()) {
    on<AlbumDetailInitEvent>(_onInit);
    _subscriptionList.addAll([EventHub.on<HubAppResumeEvent>(_onAppResume)]);
  }

  @override
  Future<void> close() {
    for (final sub in _subscriptionList) {
      sub.cancel();
    }
    return super.close();
  }

  void _onInit(AlbumDetailInitEvent event, Emitter<AlbumDetailState> emit) async {
    EasyLoading.show(maskType: .clear);
    emit(await _reload());
    EasyLoading.dismiss();
  }

  void _onAppResume(HubAppResumeEvent event) async {
    EasyLoading.show(maskType: .clear);
    emit(await _reload());
    EasyLoading.dismiss();
  }

  Future<AlbumDetailState> _reload() async {
    if (_albumId == null) {
      return const AlbumDetailNotFoundState();
    }
    final album = await AssetPathEntity.fromId(_albumId);
    final mediaList = await album.getAssetListRange(start: 0, end: await album.assetCountAsync);
    // Sort by title ascending (case-insensitive)
    mediaList.sort((a, b) {
      final aTitle = a.title?.toLowerCase() ?? '';
      final bTitle = b.title?.toLowerCase() ?? '';
      return aTitle.compareTo(bTitle);
    });
    return AlbumDetailDataState(name: album.name, mediaList: mediaList);
  }

  @override
  MediaCardBlocType mediaCardBlocAtIndex(int index) {
    final media = state.as<AlbumDetailDataState>()?.mediaList[index];
    return MediaCardBloc(media)..add(const MediaCardInitEvent());
  }
}
