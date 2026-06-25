import 'package:flutter/material.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot.dart';
import 'package:mockingbird/tab_albums/album_card/ui_album_card_snapshot_provider.dart';
import 'package:mockingbird/tab_albums/albums_grid/ui_albums_grid_snapshot.dart';
import 'ui_albums_grid_snapshot_provider_itf.dart';

class UIAlbumsGrid extends StatefulWidget {
  final UIAlbumsGridSnapshotProviderITF _provider;
  const UIAlbumsGrid(this._provider, {super.key});

  @override
  State<UIAlbumsGrid> createState() => _UIAlbumGridState();
}

class _UIAlbumGridState extends State<UIAlbumsGrid> {
  // final _albums = <Album>[];
  // var _showLoading = false;
  UIAlbumsGridSnapshot get _snapshot => widget._provider.snapshot;

  @override
  void initState() {
    super.initState();
    widget._provider.albumsGridInitState();
    _snapshot.showLoading.addListener(() {
      if (_snapshot.showLoading.value) {
        _showLoading();
      } else {
        _hideLoading();
      }
    });
    _snapshot.showUIAlbumEdit.addListener(() {
      if (_snapshot.showUIAlbumEdit.value) {
        _showUIAlbumEdit();
      }
    });
  }

  void _showUIAlbumEdit() async {
    //TODO create album/edit album
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return UIAlbumEdit(
    //       title: 'Create New Album',
    //       submitTitle: 'Create',
    //       onSubmit: (name, cover) async {
    //         final newAlbum = await DBAlbum(
    //           DBObjectBox.instance.store,
    //         ).create(name: name, cover: cover);
    //         setState(() {
    //           if (newAlbum != null) {
    //             _albums.insert(0, newAlbum);
    //           }
    //           _showLoading = false;
    //         });
    //       },
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    widget._provider.albumsGridDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _grid());
  }

  AppBar _appBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Albums'),
          ValueListenableBuilder(
            valueListenable: _snapshot.albumCardSnapshots,
            builder: (context, albumCardSnapshots, child) {
              return Text(
                '${albumCardSnapshots.length} created albums',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              );
            },
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: widget._provider.albumsGridOnAddAlbum,
          iconSize: 34,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _grid() {
    return ValueListenableBuilder(
      valueListenable: _snapshot.albumCardSnapshots,
      builder: (context, albumCardSnapshots, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: albumCardSnapshots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final albumCardSnapshot = albumCardSnapshots[index];
            albumCardSnapshot.index = index;
            return UIAlbumCard(UIAlbumCardSnapshotProvider(albumCardSnapshot));
          },
        );
      },
    );
  }

  // 开启全屏遮罩
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false, // 💡 关键：点击遮罩背景不允许关闭
      builder: (context) {
        return const PopScope(
          canPop: false, // 💡 关键：拦截物理返回键（Android 返回键），防止用户手动退出 Loading
          child: Center(
            child: CircularProgressIndicator(), // 你的 loading 动画
          ),
        );
      },
    );
  }

  // 关闭全屏遮罩
  void _hideLoading() {
    Navigator.of(context).pop(); // 💡 就像关闭普通页面一样把它 pop 掉
  }
}
