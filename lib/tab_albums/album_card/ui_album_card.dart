import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_events.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot_provider_itf.dart';
import 'package:mockingbird/tool/broadcaster.dart';

import 'ui_album_card_snapshot.dart';

enum _MoreItem {
  delete('delete'),
  edit('edit');

  final String raw;
  const _MoreItem(this.raw);
}

class UIAlbumCard extends StatefulWidget {
  final UIAlbumCardSnapshotProviderITF _provider;
  const UIAlbumCard(this._provider, {super.key});

  // final VoidCallback? _onEdit;
  // final VoidCallback? _onDelete;

  // const UIAlbumCard({
  //   super.key,
  //   // this._onEdit,
  //   // this._onDelete,
  //   // this._mediasCount = 0,
  //   // this._cover,
  //   // this._name = '',
  // });

  @override
  State<StatefulWidget> createState() => _UIAlbumCardState();
}

class _UIAlbumCardState extends State<UIAlbumCard> {
  late UIAlbumCardSnapshot _snapshot;

  @override
  void initState() {
    super.initState();

    _snapshot = widget._provider.snapshot;
  }

  @override
  void didUpdateWidget(covariant UIAlbumCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._provider.snapshot != oldWidget._provider.snapshot) {
      setState(() {
        _snapshot = widget._provider.snapshot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => widget._provider.albumCardOnTapDown(),
      onTapUp: (_) => widget._provider.albumCardOnTapUp(),
      onTapCancel: () => widget._provider.albumCardOnTapCancel(),
      onTap: () => Broadcaster().emit<UIAlbumsCardEvent>(
        UIAlbumsCardEventOnTap(_snapshot.index),
      ),
      child: Column(
            children: [
              // Cover image area
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2, //widget._state.isPressed ? 1 : 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ValueListenableBuilder(
                            valueListenable: _snapshot.cover,
                            builder: (context, cover, child) {
                              if (cover != null) {
                                return Opacity(
                                  opacity:
                                      1, //widget._state.isPressed ? 0.7 : 1.0,
                                  child: Image.file(
                                    File(cover),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Icon(
                                    Icons.video_library_rounded,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 40,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) {
                              if (value == _MoreItem.edit.raw) {
                                Broadcaster().emit<UIAlbumsCardEvent>(
                                  UIAlbumsCardEventOnEdit(_snapshot.index),
                                );
                              } else if (value == _MoreItem.delete.raw) {
                                Broadcaster().emit<UIAlbumsCardEvent>(
                                  UIAlbumsCardEventOnDelete(_snapshot.index),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: _MoreItem.edit.raw,
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: _MoreItem.delete.raw,
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete, size: 18),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              minimumSize: const Size(28, 28),
                              padding: EdgeInsets.zero,
                              tapTargetSize: .shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Name and song count below cover
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _snapshot.name,
                      builder: (context, name, child) {
                        return Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF191C1E),
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    ValueListenableBuilder(
                      valueListenable: _snapshot.mediasCount,
                      builder: (context, mediasCount, child) {
                        return Text(
                          '$mediasCount Medias',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF42474E),
                                fontWeight: FontWeight.w500,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
