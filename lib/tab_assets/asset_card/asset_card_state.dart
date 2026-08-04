import 'package:mockingbird/db/entities/en_media.dart';

class AssetCardState {
  final String name;
  final MediaType type;
  final bool playing;

  const AssetCardState({
    required this.playing,
    required this.type,
    required this.name,
  });
  const AssetCardState.empty()
    : this(playing: false, name: '', type: .video);

  AssetCardState copyWith({
    String? name,
    MediaType? type,
    bool? playing,
  }) {
    return AssetCardState(
      name: name ?? this.name,
      type: type ?? this.type,
      playing: playing ?? this.playing,
    );
  }
}
