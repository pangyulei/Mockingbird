import 'dart:io';

import '../media_card/media_card_state.dart';

class AlbumState {
  final String name;
  final File? cover;
  final List<MediaCardState> mediaStates;

  const AlbumState({
    required this.name,
    required this.cover,
    required this.mediaStates,
  });

  const AlbumState.empty()
    : this(
        cover: null,
        name: '',
        mediaStates: const [],
      );

  AlbumState copyWith({
    bool? showImport,
    String? name,
    File? Function()? cover,
    List<MediaCardState>? mediaStates,
  }) {
    return AlbumState(
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      mediaStates: mediaStates ?? this.mediaStates,
    );
  }
}
