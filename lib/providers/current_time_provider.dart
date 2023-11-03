import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StreamProvider.autoDispose<String>((ref) {
  final streamController = StreamController<String>();

  final Stream<String> stream =
      Stream.periodic(const Duration(seconds: 1), (_) {
    final DateTime now = DateTime.now();
    return _formatDateTime(now);
  });

  final StreamSubscription<String> streamSubscription = stream.listen((event) {
    streamController.add(event);
  });

  streamController.add(_formatDateTime(DateTime.now()));

  ref.onDispose(() {
    streamSubscription.cancel();
    streamController.close();
  });

  return streamController.stream;
});

String _formatDateTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}
