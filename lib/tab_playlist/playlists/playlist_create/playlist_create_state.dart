
import 'dart:io';

class PlaylistCreateState {
  final File? cover;
  final String alert;
  final bool creatable;
  const PlaylistCreateState({this.cover, this.alert = '', this.creatable = false});

  PlaylistCreateState copyWith({
    File? cover,
    String? alert,
    bool? creatable,
  }) {
    return PlaylistCreateState(
      cover: cover ?? this.cover,
      alert: alert ?? this.alert,
      creatable: creatable ?? this.creatable,
    );
  }
}