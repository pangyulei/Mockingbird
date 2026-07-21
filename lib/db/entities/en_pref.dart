import 'package:objectbox/objectbox.dart';

@Entity()
class EnPref {
  @Id()
  int id;
  final int? playingId;
  final bool loop;

  EnPref({required this.id, required this.playingId, required this.loop});

  EnPref.empty() : this(id: 0, playingId: null, loop: false);

  EnPref copyWith({int? Function()? playingId, int? versionId, bool? loop}) {
    return EnPref(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
      loop: loop ?? this.loop,
    );
  }
}
