import 'package:flutter_modular/flutter_modular.dart';

import '../backup/backup_page.dart';
import '../blessing/blessing_page.dart';
import '../date_detail/date_detail_page.dart';
import '../share/share_card_args.dart';
import '../share/share_preview_page.dart';
import 'main_page.dart';

class MainModule extends Module {
  @override
  void routes(r) {
    r.redirect('/', to: '/main/');
    r.child('/', child: (context) => const MainPage());
    r.child('/blessing', child: (context) => const BlessingPage());
    r.child('/backup', child: (context) => const BackupPage());
    r.child(
      '/share',
      child: (context) {
        final args = Modular.args.data;
        if (args is ShareCardArgs) {
          return SharePreviewPage(args: args);
        }
        if (args is DateTime) {
          return SharePreviewPage(args: ShareCardArgs.dateDetail(args));
        }
        return SharePreviewPage(args: ShareCardArgs.today());
      },
    );
    r.child(
      '/date-detail',
      child: (context) {
        final args = Modular.args.data;
        final date = args is DateTime ? args : DateTime.now();
        return DateDetailPage(date: date);
      },
    );
  }
}
