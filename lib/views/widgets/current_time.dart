import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_weather_app/providers/current_time_provider.dart';

class CurrentTime extends ConsumerWidget {
  const CurrentTime({
    super.key,
    this.style,
  });

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(currentTimeProvider);

    return currentTime.when(
      data: (value) => Text(value, style: style),
      error: (obj, stacktrace) => throw 'Error...',
      loading: () => Text('Loading...', style: style),
    );
  }
}
