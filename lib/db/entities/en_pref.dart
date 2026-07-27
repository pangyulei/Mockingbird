import 'package:objectbox/objectbox.dart';

@Entity()
class EnPref {
  @Id()
  int id;
  final int? playingId;
  final bool isLoop;

  EnPref({
    required this.id,
    required this.playingId,
    required this.isLoop,
  });

  EnPref.empty() : this(id: 0, playingId: null, isLoop: false);

  EnPref copyWith({int? Function()? playingId, bool? isLoop}) {
    return EnPref(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      isLoop: isLoop ?? this.isLoop,
    );
  }
}
