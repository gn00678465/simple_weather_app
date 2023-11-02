import 'package:flutter/cupertino.dart';

class EditableItem extends StatelessWidget {
  const EditableItem({
    super.key,
    required this.child,
    required this.isExpanded,
    this.onRightTap,
    this.onLeftTap,
  });

  final Duration duration = const Duration(milliseconds: 300);
  final double width = 40;

  final Widget child;
  final bool isExpanded;
  final void Function()? onRightTap;
  final void Function()? onLeftTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLeftTap,
          child: _animatedAction(
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: ColoredBox(
                    color: CupertinoColors.white,
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(8),
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.minus_circle_fill,
                  color: CupertinoColors.systemRed,
                  size: 24,
                ),
              ],
            ),
            isExpanded,
            width: width,
            duration: duration,
          ),
        ),
        Flexible(
          child: child,
        ),
        GestureDetector(
          onTap: onRightTap,
          child: _animatedAction(
            const Icon(
              CupertinoIcons.line_horizontal_3,
              color: CupertinoColors.inactiveGray,
            ),
            isExpanded,
            width: width,
            duration: duration,
          ),
        ),
      ],
    );
  }
}

Widget _animatedAction(
  Widget child,
  bool isExpanded, {
  required double width,
  required Duration duration,
}) {
  return AnimatedContainer(
    duration: duration,
    width: isExpanded ? width : 0,
    child: AnimatedOpacity(
      duration: duration,
      opacity: isExpanded ? 1 : 0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  );
}
