import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StreamProvider.autoDispose<String>((ref) {
  final streamController = StreamController<String>();

  Stream.periodic(const Duration(seconds: 1), (_) {
    final DateTime now = DateTime.now();
    streamController.add(_formatDateTime(now));
  });

  streamController.add(_formatDateTime(DateTime.now()));

  return streamController.stream;
});

String _formatDateTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}
