

import 'package:flutter/material.dart';

import 'package:mockingbird/tab_albums/album_detail/media_card/media_card_interface_ui_events.dart';

import 'album_detail_interface_ui_events.dart';
import 'album_detail_state.dart';
import 'media_card/media_card_widget.dart';

class AlbumDetailWidget extends StatefulWidget {
  final AlbumDetailInterfaceUIEvents _logic;
  const AlbumDetailWidget(this._logic, {super.key});

  @override
  State<AlbumDetailWidget> createState() => _WidgetFactory();


}

class _WidgetFactory extends State<AlbumDetailWidget> implements MediaCardInterfaceUIEvents {
  AlbumDetailState _state = const AlbumDetailState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(widget._logic.albumDetailInitState());
  }

  Future<void> _updateStateByStream(Stream<AlbumDetailState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(AlbumDetailState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  void mediaCardClickPlay(int index) {
    widget._logic.albumDetailPlayMedia(index, context);
  }

  @override
  Widget build(BuildContext context) {
    if (_state.showLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }



    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(context),
          if (_state.mediaStates.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No medias yet. Tap + to add.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final mediaState = _state.mediaStates[index];
                    return MediaCardWidget(state: mediaState, logic: this);
                  },
                  childCount: _state.mediaStates.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _state.name,
          style: TextStyle(
            color: _state.cover != null ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            shadows: _state.cover != null
                ? [const Shadow(color: Colors.black, blurRadius: 4)]
                : null,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_state.cover != null)
              Image.file(_state.cover!, fit: BoxFit.cover)
            else
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            if (_state.cover != null)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 10),
      leading: IconButton.filledTonal(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        // const Spacer(flex: 12,),
        IconButton.filledTonal(
          icon: const Icon(Icons.download),
          onPressed: () async {
            _updateStateByStream(widget._logic.albumDetailImportMedias(_state));
          },
        ),

      ],
    );
  }

}
