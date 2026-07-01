import 'dart:io';
import '../media_card/media_card_state.dart';

class AlbumDetailState {
  final String name;
  final File? cover;
  final bool showLoading;
  final bool showImport;
  final List<MediaCardState> mediaStates;

  const AlbumDetailState({
    required this.showImport,
    required this.name,
    required this.cover,
    required this.showLoading,
    required this.mediaStates,
  });

  factory AlbumDetailState.empty() {
    return const AlbumDetailState(
      name: '',
      cover: null,
      showLoading: false,
      mediaStates: [],
      showImport: false,
    );
  }

  AlbumDetailState copyWith({
    bool? showImport,
    String? name,
    File? Function()? cover,
    bool? showLoading,
    List<MediaCardState>? mediaStates,
  }) {
    return AlbumDetailState(
      showImport: showImport ?? this.showImport,
      name: name ?? this.name,
      cover: cover == null ? this.cover : cover(),
      showLoading: showLoading ?? this.showLoading,
      mediaStates: mediaStates ?? this.mediaStates,
    );
  }
}
