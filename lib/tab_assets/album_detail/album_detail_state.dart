import 'dart:io';

sealed class AlbumDetailState {
  const AlbumDetailState();
}

class AlbumDetailNull extends AlbumDetailState {
  const AlbumDetailNull();
}

class AlbumDetailData extends AlbumDetailState {
  final String name;
  final File? cover;
  final List<int> mediaIdList;

  const AlbumDetailData({
    required this.name,
    required this.cover,
    required this.mediaIdList,
  });

  AlbumDetailData copyWith({
    String? name,
    File? Function()? cover,
    List<int>? mediaIdList,
  }) {
    return AlbumDetailData(
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      mediaIdList: mediaIdList ?? this.mediaIdList,
    );
  }
}
