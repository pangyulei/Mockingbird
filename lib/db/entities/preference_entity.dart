import 'package:objectbox/objectbox.dart';

@Entity()
class PreferenceEntity {
  @Id()
  int id;
  final bool loop;

  PreferenceEntity({
    required this.id,
    required this.loop,
  });

  PreferenceEntity.empty()
    : this(id: 0, loop: false, );

  PreferenceEntity copyWith({
    bool? loop,
  }) {
    return PreferenceEntity(
      id: id,
      loop: loop ?? this.loop,
    );
  }
}
