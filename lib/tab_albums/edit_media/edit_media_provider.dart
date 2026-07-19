import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockingbird/db/entities/en_media.dart';
import 'package:mockingbird/db/providers/db_album_list_provider.dart';
import 'package:mockingbird/tab_albums/edit_media/edit_media_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_media_provider.g.dart';

@riverpod
class EditMedia extends _$EditMedia {
  EnMedia? _media;
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
    final EnMedia? media = ref.watch(
      dbAlbumListProvider
          .select((av) => av.value ?? [])
          .select((al) => [for (final a in al) a.medias])
          .select((mll) => mll.expand((e) => e))
          .select((ml) => {for (final m in ml) m.id: m})
          .select((mm) => mm[id]),
    );
    _media = media;
    if (media == null) {
      return EditMediaState(
        nameController: nameController,
        enableSubmit: false,
      );
    }
    nameController.text = media.name;
    return EditMediaState(nameController: nameController, enableSubmit: false);
  }

  Future<void> submit() async {
    final media = _media;
    if (media == null) return;

    EasyLoading.show(maskType: .clear);
    await ref
        .read(dbAlbumListProvider.notifier)
        .updateMedia(media, state.nameController.text);
    EasyLoading.dismiss();
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
