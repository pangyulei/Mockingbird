import 'package:flutter/cupertino.dart';

class EditMediaState {
  final TextEditingController nameController;
  final bool enableSubmit;
  const EditMediaState({
    required this.nameController,
    required this.enableSubmit,
  });
  EditMediaState copyWith({bool? enableSubmit}) {
    return EditMediaState(
      nameController: nameController,
      enableSubmit: enableSubmit ?? this.enableSubmit,
    );
  }
}
