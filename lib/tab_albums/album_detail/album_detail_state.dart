import 'dart:io';
import 'media_card/media_card_state.dart';

class AlbumDetailState {
  final String name;
  final File? cover;
  final bool showLoading;
  final List<MediaCardState> mediaStates;

  const AlbumDetailState({
    this.name = '',
    this.cover,
    this.showLoading = false,
    this.mediaStates = const [],
  });

  AlbumDetailState copyWith({
    String? name,
    File? cover,
    bool? showLoading,
    List<MediaCardState>? mediaStates,
  }) {
    return AlbumDetailState(
      name: name ?? this.name,
      cover: cover ?? this.cover,
      showLoading: showLoading ?? this.showLoading,
      mediaStates: mediaStates ?? this.mediaStates,
    );
  }
}
