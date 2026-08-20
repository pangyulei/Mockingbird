import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

extension ObjectHelper on Object {
  T? as<T>() {
    return (this is T) ? (this as T) : null;
  }
}

extension StatelessHelper on StatelessWidget {
  void showLoading(bool show) {
    if (show) {
      EasyLoading.show(maskType: .clear);
    } else {
      EasyLoading.dismiss();
    }
  }
}

extension StateHelper<T extends StatefulWidget> on State<T> {
  void showLoading(bool show) {
    if (show) {
      EasyLoading.show(maskType: .clear);
    } else {
      EasyLoading.dismiss();
    }
  }
}

extension IterableHelper<E> on Iterable<E> {
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

extension ScrollHelper on ItemScrollController {
  void safeJumpTo(int? index, {double alignment = 0}) {
    if (isAttached && index != null) {
      debugPrint('${identityHashCode(this)} will jump to index $index');
      jumpTo(index: index, alignment: alignment);
    } else {
      debugPrint(
        '${identityHashCode(this)} jump fail, attached $isAttached, index $index',
      );
    }
  }

  void safeScrollTo(
    int? index, {
    double alignment = 0,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    if (isAttached && index != null) {
      debugPrint(
        '${identityHashCode(this)} will scroll to index $index align $alignment',
      );
      scrollTo(index: index, duration: duration, alignment: alignment);
    } else {
      debugPrint(
        '${identityHashCode(this)} scroll fail, attached $isAttached, index $index',
      );
    }
  }
}
