import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

class PullDownActions extends StatelessWidget {
  const PullDownActions({
    super.key,
    required this.onPressEdit,
    required this.onPressUnit,
  });

  final void Function() onPressEdit;
  final void Function() onPressUnit;

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem(
          title: '編輯列表',
          icon: CupertinoIcons.pencil,
          itemTheme: const PullDownMenuItemTheme(
            textStyle: TextStyle(color: CupertinoColors.white, fontSize: 16),
          ),
          onTap: onPressEdit,
        ),
        PullDownMenuDivider.large(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor),
        PullDownMenuItem(
          title: '單位',
          icon: CupertinoIcons.chart_bar,
          itemTheme: const PullDownMenuItemTheme(
            textStyle: TextStyle(color: CupertinoColors.white, fontSize: 16),
          ),
          onTap: onPressUnit,
        ),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        onPressed: showMenu,
        padding: EdgeInsets.zero,
        child: const Icon(
          CupertinoIcons.ellipsis_circle,
          size: 24,
          color: CupertinoColors.white,
        ),
      ),
      routeTheme: const PullDownMenuRouteTheme(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        width: 200,
      ),
    );
  }
}
