import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension IterableExtension<E> on Iterable<E> {
  int? firstIndexWhereOrNull(bool Function(E) test) {
    int i = 0;
    for (final element in this) {
      if (test(element)) {
        return i;
      }
      i++;
    }
    return null;
  }
}

extension Loading on StatefulWidget {
  void showLoading(bool show) {
    if (show && !EasyLoading.isShow) {
      debugPrint('easyloading: $runtimeType show');
      EasyLoading.show(maskType: .clear);

    } else if (!show && EasyLoading.isShow){
      debugPrint('easyloading: $runtimeType dismiss');
      EasyLoading.dismiss();
    }
  }
}

