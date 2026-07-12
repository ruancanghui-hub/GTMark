import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'l10n_test_harness.dart';
import 'package:qingbushui/shared/assets/qw_assets.dart';
import 'package:qingbushui/shared/widgets/qw_asset_icon.dart';

void main() {
  testWidgets('Crystal Aqua asset icons render through shared widget', (
    tester,
  ) async {
    await pumpL10nApp(
      tester,
      Scaffold(
        body: Row(
          children: const [
            QwAssetIcon(
              asset: QwAssets.navToday,
              label: 'Today crystal icon',
            ),
            QwAssetIcon(
              asset: QwAssets.drinkCoffee,
              label: 'Coffee crystal icon',
            ),
            QwAssetIcon(
              asset: QwAssets.settingReminder,
              label: 'Reminder crystal icon',
            ),
            QwAssetIcon(
              asset: QwAssets.insightWaterBalance,
              label: 'Water balance crystal illustration',
            ),
          ],
        ),
      ),
    );

    expect(find.byType(QwAssetIcon), findsNWidgets(4));
    expect(find.bySemanticsLabel('Today crystal icon'), findsOneWidget);
    expect(find.bySemanticsLabel('Coffee crystal icon'), findsOneWidget);
    expect(find.bySemanticsLabel('Reminder crystal icon'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Water balance crystal illustration'),
      findsOneWidget,
    );
  });
}
