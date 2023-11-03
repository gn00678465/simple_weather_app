import 'package:flutter/material.dart';

class FadeInOut extends StatefulWidget {
  const FadeInOut({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration animationDuration;

  @override
  State<FadeInOut> createState() => _FadeInOut();
}

class _FadeInOut extends State<FadeInOut> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Widget get child => widget.child;
  Duration get animationDuration => widget.animationDuration;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: animationDuration);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: child,
    );
  }
}
