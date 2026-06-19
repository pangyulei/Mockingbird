import 'package:flutter/cupertino.dart';
import 'package:mockingbird/model/media.dart';

class MediaCardState {
  final String name;
  final MediaType type;
  final bool hasSubtitle;

  const MediaCardState({
    this.type = .audio,
    this.name = '',
    this.hasSubtitle = false,
  });
}