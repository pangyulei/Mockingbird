import 'package:photo_manager/photo_manager.dart';

class MediaCardState {
  final String name;
  final AssetType type;
  final bool playing;
  final bool hasSubtitle;

  const MediaCardState({
    required this.playing,
    required this.hasSubtitle,
    required this.type,
    required this.name,
  });
  const MediaCardState.empty()
    : this(playing: false, name: '', type: .video, hasSubtitle: false);

  MediaCardState copyWith({
    String? name,
    AssetType? type,
    bool? playing,
    bool? hasSubtitle,
  }) {
    return MediaCardState(
      hasSubtitle: hasSubtitle ?? this.hasSubtitle,
      name: name ?? this.name,
      type: type ?? this.type,
      playing: playing ?? this.playing,
    );
  }
}
