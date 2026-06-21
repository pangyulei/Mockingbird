
import 'package:mockingbird/model/media.dart';

class MediaCardState {
  final String name;
  final MediaType type;
  final bool hasSubtitle;
  final int index;

  const MediaCardState({
    this.type = .video,
    this.name = '',
    this.hasSubtitle = false,
    this.index = 0,
  });
}