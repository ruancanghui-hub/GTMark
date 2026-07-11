import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'app_tab_icons.dart';

/// 二级页左侧返回按钮（[AppTabIcons.back]），行为与 TDesign 默认返回一致。
List<TDNavBarItem> fdNavBarBackItems(BuildContext context) {
  final td = TDTheme.of(context);
  return <TDNavBarItem>[
    TDNavBarItem(
      iconWidget: appTabIconAsset(
        AppTabIcons.back,
        td.textColorPrimary,
        size: 28,
      ),
      action: () => Navigator.maybePop(context),
    ),
  ];
}
