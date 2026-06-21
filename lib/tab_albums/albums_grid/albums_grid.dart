import 'dart:io';

import 'package:flutter/material.dart';

import '../../db/db_album.dart';
import '../../db/db_objectbox.dart';
import '../../model/album.dart';
import '../album_edit/album_edit.dart';
import '../albums_nav/albums_nav_route.dart';
import 'album_card/album_card.dart';



class AlbumsGrid extends StatefulWidget {
  const AlbumsGrid({super.key});

  @override
  State<AlbumsGrid> createState() => _State();
}

class _State extends State<AlbumsGrid> {
  final _albums = <Album>[];
  var _showLoading = false;
  var _showEditButtons = false;

  @override
  void initState() {
    super.initState();
    _initAlbums();
  }

  // 抽离出清晰的异步业务方法
  Future<void> _initAlbums() async {
    setState(() {
      _showLoading = true;
    });
    // 执行数据库查询
    final albums = await DBAlbum(DBObjectBox.instance.store).getAll();

    // 🌟 核心安全检查：如果异步结束时，用户已经离开了当前页面，直接终止，防止崩溃
    if (!mounted) return;

    // 🌟 核心修复：在 setState 中更新数据，通知 UI 刷新
    setState(() {
      _albums.clear();
      _albums.addAll(albums);
      _showLoading = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          _gridWidget(),
          if (_showLoading) _loadingWidget(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          Text(
            '${_albums.length} created albums',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _onEditGrid,
          icon: Icon(_showEditButtons ? Icons.check : Icons.edit),
          iconSize: 24,
        ),
        IconButton(
          onPressed: _onAdd,
          iconSize: 34,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _gridWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _albums.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final album = _albums[index];
        return DragTarget<Album>(
          onWillAcceptWithDetails: (dragged) => album.id != dragged.data.id,
          onAcceptWithDetails: (dragged) async => await _swapAlbums(dragged.data, album),
          builder: (context, candidateData, rejectedData) {
            final bool isTarget = candidateData.isNotEmpty;
            return LongPressDraggable<Album>(
              data: album,
              axis: null,
              maxSimultaneousDrags: 1,
              feedback: SizedBox(
                width: 160,
                height: 160,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  child: Opacity(
                    opacity: 0.8,
                    child: AlbumCard(
                      album: album,
                      showEditButtons: _showEditButtons,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: AlbumCard(
                  album: album,
                  showEditButtons: _showEditButtons,
                ),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: isTarget
                    ? BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: AlbumCard(
                  album: album,
                  onEdit: () => _onEditAlbum(album),
                  onDelete: () => _onDeleteAlbum(album),
                  onTap: () => _onTapAlbum(album),
                  showEditButtons: _showEditButtons,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _swapAlbums(Album draggedAlbum, Album targetAlbum) async {
    setState(() {
      _showLoading = true;
    });
    int fromIndex = _albums.indexOf(draggedAlbum);
    int toIndex = _albums.indexOf(targetAlbum);
    //swap db sortorder first, then swap their place in List
    (draggedAlbum, targetAlbum) = await DBAlbum(
      DBObjectBox.instance.store,
    ).swapSortOrder(draggedAlbum, targetAlbum);
    setState(() {
      _albums[fromIndex] = targetAlbum;
      _albums[toIndex] = draggedAlbum;
      _showLoading = false;
    });
  }

  Future<void> _onAdd() async {
    setState(() => _showEditButtons = false);
    await showDialog(context: context, builder: (context) {
      return AlbumEdit(
        title: 'Create New Album',
        submitTitle: 'Create',
        onSubmit: (name, cover) async {
          final newAlbum = await DBAlbum(DBObjectBox.instance.store).create(
            name: name,
            cover: cover,
          );
          setState(() {
            if (newAlbum != null) {
              _albums.insert(0, newAlbum);
            }
            _showLoading = false;
          });
        },
      );
    },);
  }

  void _onEditGrid() {
    setState(() => _showEditButtons = !_showEditButtons);
  }

  void _onTapAlbum(Album album) {
    setState(() => _showEditButtons = false);
    Navigator.pushNamed(context, AlbumsNavRoute.urlStrForAlbumDetail(album.id));
  }

  Future<void> _onEditAlbum(Album album) async {
    await showDialog(context: context, builder: (context) {
      return AlbumEdit(
        name: album.name,
        cover: album.cover != null ? File(album.cover!) : null,
        title: 'Edit Album',
        submitTitle: 'Save',
        onSubmit: (name, cover) async {
          bool isIdentical() {
            if (name.trim() != album.name) return false;
            if (cover == null && album.cover == null) return true;
            return cover != null && album.cover != null && cover.path == album.cover;
          }
          if (!isIdentical()) {
            setState(() {
              _showLoading = true;
            });
            final updatedAlbum = await DBAlbum(DBObjectBox.instance.store).update(
              album: album,
              name: name,
              cover: cover,
            );
            setState(() {
              int index = _albums.indexOf(album);
              _albums[index] = updatedAlbum;
              _showLoading = false;
            });
          }
        },
      );
    },);
  }

  Future<void> _onDeleteAlbum(Album album) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Album'),
        content: Text(
          'Are you sure you want to delete "${album.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

    setState(() {
      _showLoading = true;
    });

    // Remove from database
    await DBAlbum(DBObjectBox.instance.store).remove(album);

    // Update state with remaining albums
    setState(() {
      _albums.remove(album);
      _showLoading = false;
    });

  }
}
