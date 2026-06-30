import 'dart:io';

import 'package:mockingbird/model/album.dart';
import 'package:mockingbird/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/media.dart';
import '../model/subtitle.dart';
import '../model/sentence.dart';

class DBAlbum {
  final Store _store;
  DBAlbum(this._store);

  Future<Directory> get _coversDir async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory(p.join(appDir.path, 'album_covers'));
  }

  Future<String> get _newCoverPath async {
    final coversDir = await _coversDir;
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    // Generate a unique filename using timestamp and original extension
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}';
    return p.join(coversDir.path, fileName);
  }

  Future<Album?> create({required String name, File? cover}) async {
    //校验 name
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    //保存封面
    final String? coverPath;
    if (cover != null) {
      coverPath = await _newCoverPath;
      await cover.copy(coverPath);
    } else {
      coverPath = null;
    }
    //获取 最大SortOrder
    final albumBox = _store.box<Album>();
    final query = albumBox
        .query()
        .order(Album_.sortOrder, flags: Order.descending)
        .build();
    final maxSortOrderAlbum = await query.findFirstAsync();
    query.close();

    final sortOrder = maxSortOrderAlbum != null
        ? maxSortOrderAlbum.sortOrder + 1
        : 0;
    return await _store.box<Album>().putAndGetAsync(
      Album(name: trimmedName, sortOrder: sortOrder, cover: coverPath),
    );
  }

  Future<Album> update({
    required Album album,
    required String name,
    File? Function()? coverFunc,
  }) async {
    Album updateAlbum = album.copyWith();
    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      updateAlbum = updateAlbum.copyWith(name: trimmedName);
    }
    if (coverFunc == null) {
      //dont update album's cover
    } else {
      final File? cover = coverFunc();
      if (cover == null) {
        //remove cover
        updateAlbum = await _removeCoverFile(updateAlbum);
      } else if (cover.path != album.cover) {
        //replace old cover to new cover
        updateAlbum = await _removeCoverFile(updateAlbum);
        final coverPath = await _newCoverPath;
        await cover.copy(coverPath);
        updateAlbum = updateAlbum.copyWith(cover: () => coverPath);
      }
    }
    if (updateAlbum.cover != album.cover || updateAlbum.name != album.name) {
      return await _store.box<Album>().putAndGetAsync(updateAlbum);
    } else {
      return album;
    }
  }

  Future<Album> _removeCoverFile(Album album) async {
    if (album.cover != null) {
      final oldCover = File(album.cover!);
      if (await oldCover.exists()) {
        await oldCover.delete();
      }
      return album.copyWith(cover: () => null);
    } else {
      return album;
    }
  }

  Future<List<Album>> getAll() async {
    final query = _store
        .box<Album>()
        .query()
        .order(Album_.sortOrder, flags: Order.descending)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  Future<Album?> get(int id) async {
    return await _store.box<Album>().getAsync(id);
  }

  Future<(Album, Album)> swapSortOrder(Album aAlbum, Album bAlbum) async {
    final aSortOrder = aAlbum.sortOrder;
    aAlbum = aAlbum.copyWith(sortOrder: bAlbum.sortOrder);
    bAlbum = bAlbum.copyWith(sortOrder: aSortOrder);
    await _store.box<Album>().putManyAsync([aAlbum, bAlbum]);
    return (aAlbum, bAlbum);
  }

  Future<void> remove(Album album) async {
    await removeMany([album]);
  }

  Future<void> removeMany(List<Album> albums) async {
    if (albums.isEmpty) return;
    albums = albums.where((a) => a.id > 0).toList();

    await _store.runInTransactionAsync(TxMode.write, (
      Store store,
      List<int> albumIds,
    ) {
      final mediaBox = store.box<Media>();
      final subtitleBox = store.box<Subtitle>();
      final sentenceBox = store.box<Sentence>();
      final albumBox = store.box<Album>();

      final albumIdsSet = albumIds.toSet();
      final medias = mediaBox
          .getAll()
          .map((m) {
            m.albums.removeWhere((a) => albumIdsSet.contains(a.id));
            return m;
          })
          .where((m) => m.albums.isEmpty)
          .toList();
      final mediaIds = medias.map((m) => m.id).toList();
      final subtitles = medias
          .map((m) => m.subtitles)
          .expand((e) => e)
          .toList();
      final subtitleIds = subtitles.map((s) => s.id).toList();
      final sentences = subtitles
          .map((st) => st.sentences)
          .expand((e) => e)
          .toList();
      final sentenceIds = sentences.map((s) => s.id).toList();
      albumBox.removeMany(albumIds);
      mediaBox.removeMany(mediaIds);
      subtitleBox.removeMany(subtitleIds);
      sentenceBox.removeMany(sentenceIds);
    }, [for(final a in albums) a.id]);

    // Delete cover files for removed playlists
    final uselessCovers = albums
        .where((a) => a.cover != null)
        .map((a) => File(a.cover!));

    final removeCovers = uselessCovers.map((cover) async {
      if (await cover.exists()) {
        await cover.delete();
      }
    });
    await Future.wait(removeCovers);
  }
}
