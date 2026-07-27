
import 'package:mockingbird/db/entities/en_media.dart';

class MediaCardState {
  final String name;
  final MediaType type;
  final bool hasSubtitle;
  final bool isPlaying;

  const MediaCardState({
    required this.isPlaying,
    required this.type,
    required this.name,
    required this.hasSubtitle,
  });


  MediaCardState copyWith({
    String? name,
    MediaType? type,
    bool? hasSubtitle,
    bool? isPlaying,
  }) {
    return MediaCardState(
      name: name ?? this.name,
      type: type ?? this.type,
      hasSubtitle: hasSubtitle ?? this.hasSubtitle,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}