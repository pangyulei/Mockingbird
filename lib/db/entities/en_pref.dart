import 'package:objectbox/objectbox.dart';

@Entity()
class EnPref {
  @Id()
  int id;
  int versionId;
  final int? playingId;

  EnPref({
    required this.id,
    required this.playingId,
    required this.versionId,
  });

  EnPref.empty()
    : this(id: 0, playingId: null, versionId: 0);

  EnPref copyWith({
    int? Function()? playingId,
    int? versionId,
  }) {
    return EnPref(
      id: id,
      versionId: versionId ?? this.versionId,
      playingId: playingId == null
          ? this.playingId
          : playingId(),
    );
  }

  EnPref incVersionId() {
    return copyWith(versionId: versionId + 1);
  }
}
