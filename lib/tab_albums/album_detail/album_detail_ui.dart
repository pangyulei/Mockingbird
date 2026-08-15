import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_bloc.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_event.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tool/extensions.dart';

import '../media_card/media_card_ui.dart';

class AlbumDetailUI extends StatelessWidget {
  final String _id;

  const AlbumDetailUI(this._id, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumDetailBloc(_id)..add(const AlbumDetailLoadingEvent()),
      child: Builder(
        builder: (context) {
          final stateType = context.select<AlbumDetailBloc, Type>(
            (bloc) => bloc.state.runtimeType,
          );
          if (stateType is AlbumDetailLoadingState) {
            EasyLoading.show(maskType: .clear);
          } else {
            EasyLoading.dismiss();
          }
          switch (stateType) {
            case AlbumDetailLoadingState:
              return _pageForLoading();
            case AlbumDetailNotFoundState:
              return _pageForNotFound();
            case AlbumDetailEmptyState:
              return _pageForEmpty();
            case AlbumDetailDataState:
              return _pageForData(context);
            default:
              assert(false, 'state type $stateType not handled');
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _pageForLoading() {
    return Scaffold(appBar: AppBar());
  }

  Widget _pageForData(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final (name, count) = context
                .select<AlbumDetailBloc, (String, int)>((bloc) {
                  final data = bloc.state.as<AlbumDetailDataState>();
                  return (
                    data?.name ?? 'Album Not Found',
                    data?.mediaIdList.length ?? 0,
                  );
                });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  '$count medias',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: Builder(
        builder: (context) {
          final mediaIdList = context.select<AlbumDetailBloc, List<String>>(
            (bloc) => bloc.state.as<AlbumDetailDataState>()?.mediaIdList ?? [],
          );
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: mediaIdList.length,
            itemBuilder: (context, i) {
              return MediaCardUI(mediaIdList[i]);
            },
          );
        },
      ),
    );
  }

  Widget _pageForNotFound() {
    return Scaffold(
      appBar: AppBar(title: const Text('?')),
      body: const Center(child: Text('Album not found')),
    );
  }

  Widget _pageForEmpty() {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final name = context.select<AlbumDetailBloc, String>(
              (bloc) => bloc.state.as<AlbumDetailEmptyState>()?.name ?? '',
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  '0 medias',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: const Center(child: Text('Album is empty')),
    );
  }
}
