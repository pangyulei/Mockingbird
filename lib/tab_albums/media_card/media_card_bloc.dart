import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingbird/app/app_route.dart';
import 'package:mockingbird/db/db.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_event.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_state.dart';
import 'package:mockingbird/tool/event_hub.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaCardBloc extends Bloc<MediaCardEvent, MediaCardState> {
  final String _id;
  MediaCardBloc(this._id) : super(const MediaCardState.empty()) {
    on<MediaCardInitEvent>(_onInit);
    on<MediaCardClickEvent>(_onClick);
  }

  void _onClick(MediaCardClickEvent event, Emitter<MediaCardState> emit) async {
    event.context.go(AppRoute.player(mediaId: event.mediaId));
  }

  void _onInit(_, Emitter<MediaCardState> emit) async {
    final media = await AssetEntity.fromId(_id);
    if (media == null) {
      emit(const MediaCardState.empty());
      return;
    }
    final metadata = await DB.loadMetadata();
    emit(
      MediaCardState(
        name: media.title ?? '',
        type: media.type,
        playing: _id == metadata.playingMediaId,
        hasSubtitle: false, //TODO hassubtitle
      ),
    );
  }
}
