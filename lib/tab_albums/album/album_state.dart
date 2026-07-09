import 'dart:io';

import '../media_card/media_card_state.dart';

class AlbumState {
  final String name;
  final File? cover;
  final bool showLoading;
  final bool showImport;
  final List<MediaCardState> mediaStates;

  const AlbumState({
    required this.showImport,
    required this.name,
    required this.cover,
    required this.showLoading,
    required this.mediaStates,
  });

  const AlbumState.empty()
    : this(
        cover: null,
        name: '',
        showLoading: false,
        mediaStates: const [],
        showImport: false,
      );

  AlbumState copyWith({
    bool? showImport,
    String? name,
    File? Function()? cover,
    bool? showLoading,
    List<MediaCardState>? mediaStates,
  }) {
    return AlbumState(
      showImport: showImport ?? this.showImport,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      showLoading: showLoading ?? this.showLoading,
      mediaStates: mediaStates ?? this.mediaStates,
    );
  }
}
