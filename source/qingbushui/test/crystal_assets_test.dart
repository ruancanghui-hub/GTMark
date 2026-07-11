import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/shared/assets/qw_assets.dart';
import 'package:qingbushui/shared/widgets/qw_asset_icon.dart';

void main() {
  testWidgets('Crystal Aqua asset icons render through shared widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
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
      ),
    );

    expect(find.byType(Image), findsNWidgets(4));
    expect(find.bySemanticsLabel('Today crystal icon'), findsOneWidget);
    expect(find.bySemanticsLabel('Coffee crystal icon'), findsOneWidget);
    expect(find.bySemanticsLabel('Reminder crystal icon'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Water balance crystal illustration'),
      findsOneWidget,
    );
  });
}
