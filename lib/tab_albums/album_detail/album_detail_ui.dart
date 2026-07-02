import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_detail/album_detail_state.dart';
import 'package:mockingbird/tab_albums/media_card/media_card_ui.dart';

abstract interface class AlbumDetailUIOutputITF
    implements MediaCardUIOutputITF {
  void albumDetail_onImportMedias();
}

class AlbumDetailUI extends StatelessWidget {
  final AlbumDetailState _state;
  final AlbumDetailUIOutputITF _logic;
  const AlbumDetailUI(this._state, this._logic, {super.key});

  @override
  Widget build(BuildContext ctx) {
    return Stack(children: [_page(ctx), if (_state.showLoading) _loading()]);
  }

  Widget _loading() {
    return ColoredBox(
      color: Colors.black.withAlpha(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _page(BuildContext ctx) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(ctx),
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final mediaState = _state.mediaStates[index];
                  return MediaCardUI(state: mediaState, logic: _logic);
                }, childCount: _state.mediaStates.length),
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
            color: _state.cover != null
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
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
                    colors: [Colors.transparent, Colors.black54],
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
        if (_state.showImport)
          IconButton.filledTonal(
            icon: const Icon(Icons.download),
            onPressed: _logic.albumDetail_onImportMedias,
          ),
      ],
    );
  }
}
