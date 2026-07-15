import 'package:objectbox/objectbox.dart';

@Entity()
class EnPref {
  @Id()
  int id;

  final int? playingId;
  EnPref({required this.id, required this.playingId});
  EnPref.empty() : this(id: 0, playingId: null);

  EnPref copyWith({int? Function()? playingId}) {
    return EnPref(
      id: id,
      playingId: playingId == null ? this.playingId : playingId(),
    );
  }
}
