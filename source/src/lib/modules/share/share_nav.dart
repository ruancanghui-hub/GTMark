import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/routes/app_routes.dart';
import 'share_card_args.dart';

/// 打开分享预览（统一传参入口）。
void openSharePreview(BuildContext context, [ShareCardArgs? args]) {
  Modular.to.pushNamed(
    '${AppRoutes.main}share',
    arguments: args ?? ShareCardArgs.today(),
  );
}
