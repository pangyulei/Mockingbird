import 'package:flutter/cupertino.dart';
import 'package:mockingbird/model/media.dart';

class MediaCardState {
  final String name;
  final MediaType type;
  final bool hasSubtitle;
  final int index;

  const MediaCardState({
    required this.type,
    required this.name,
    required this.hasSubtitle,
    required this.index,
  });
}