import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

extension Loading on Object {
  void showLoading(bool show) {
    if (show && !EasyLoading.isShow) {
      debugPrint('easyloading: $runtimeType show');
      EasyLoading.show(maskType: .clear);
    } else if (!show && EasyLoading.isShow) {
      debugPrint('easyloading: $runtimeType dismiss');
      EasyLoading.dismiss();
    }
  }
}

extension SafeScroll on ItemScrollController {
  void safeJumpTo(int? index, {double alignment = 0}) {
    if (isAttached && index != null) {
      jumpTo(index: index, alignment: alignment);
    } else {
      debugPrint('${identityHashCode(this)} jump fail, scroll is not attached');
    }
  }

  void safeScrollTo(
    int? index, {
    double alignment = 0,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    if (isAttached && index != null) {
      scrollTo(index: index, duration: duration, alignment: alignment);
    } else {
      debugPrint(
        '${identityHashCode(this)} scroll fail, scroll is not attached',
      );
    }
  }
}
