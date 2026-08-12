import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    debugPrint('[Provider Updated] ${context.provider.name ?? context.provider.runtimeType}');
    debugPrint('  Old: $previousValue');
    debugPrint('  New: $newValue');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    debugPrint('[Provider Disposed] ${context.provider.name ?? context.provider.runtimeType}');
  }
}
