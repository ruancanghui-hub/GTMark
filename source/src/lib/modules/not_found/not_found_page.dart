import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lianji/l10n/gen/app_localizations.dart';

import '../../app/routes/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundTitle)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Modular.to.navigate(AppRoutes.splash),
          child: Text(l10n.notFoundBackHome),
        ),
      ),
    );
  }
}
