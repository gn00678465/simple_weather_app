import 'dart:async';

typedef Debounceable<S, T> = Future<S?> Function(T parameter);

class _DebounceTimer {
  _DebounceTimer({
    required this.debounceDuration,
  }) {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Duration debounceDuration;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;
}

class _CancelException implements Exception {
  const _CancelException();
}

/// Returns a new function that is a debounced version of the given function.
///
Debounceable<S, T> debounce<S, T>(Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;
  const Duration debounceDuration = Duration(milliseconds: 500);

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer(debounceDuration: debounceDuration);
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}
