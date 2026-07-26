import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/db/providers/db_media_provider.dart';
import 'package:mockingbird/tab_albums/edit_media/edit_media_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_media_provider.g.dart';

@riverpod
class EditMedia extends _$EditMedia {
  @override
  EditMediaState build(int? id) {
    final nameController = TextEditingController();
    ref.onDispose(() => nameController.dispose());
    if (id == null) {
      return EditMediaState(
        nameController: nameController,
        enableSubmit: false,
      );
    }
    final EnMedia? media = ref.watch(dbMediaProvider(id)).value;
    if (media == null) {
      return EditMediaState(
        nameController: nameController,
        enableSubmit: false,
      );
    }
    nameController.text = media.name;
    return EditMediaState(nameController: nameController, enableSubmit: false);
  }

  EnMedia? get _media => ref.read(
    dbAlbumListProvider
        .select((st) => st.value ?? [])
        .select((al) => al.map((a) => a.mediaList).flattened)
        .select((ml) => {for (final m in ml) m.id: m})
        .select((mm) => mm[id]),
  );

  Future<void> submit() async {
    final media = _media;
    if (media == null) return;

    await ref
        .read(dbMediaProvider(id).notifier)
        .edit(name: state.nameController.text);
  }

  void updateName(String newName) {
    final enableSubmit = _isSubmitEnable(_media?.name, newName);
    state = state.copyWith(enableSubmit: enableSubmit);
  }

  bool _isSubmitEnable(String? oldName, String newName) {
    if (oldName == null) return false;
    final trimmedNewName = newName.trim();
    if (trimmedNewName.isEmpty) {
      return false;
    }
    return trimmedNewName != oldName;
  }
}
