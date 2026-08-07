import 'package:photo_manager/photo_manager.dart';

class MediaCardState {
  final String name;
  final AssetType type;
  final bool playing;

  const MediaCardState({
    required this.playing,
    required this.type,
    required this.name,
  });
  const MediaCardState.empty()
    : this(playing: false, name: '', type: .video);

  MediaCardState copyWith({
    String? name,
    AssetType? type,
    bool? playing,
  }) {
    return MediaCardState(
      name: name ?? this.name,
      type: type ?? this.type,
      playing: playing ?? this.playing,
    );
  }
}
