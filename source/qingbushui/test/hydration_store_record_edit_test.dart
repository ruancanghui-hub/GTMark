import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/core/hydration/hydration_store.dart';
import 'package:qingbushui/core/hydration/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await HydrationStore.init();
  });

  test('updates an intake record and keeps it persisted', () async {
    final store = HydrationStore.of();
    await store.addIntake(
      drinkType: DrinkType.water,
      volumeMl: 240,
      at: DateTime(2026, 7, 12, 8),
    );

    final original = store.records.single;
    final updated = original.copyWith(
      drinkType: DrinkType.tea,
      volumeMl: 360,
      recordedAt: DateTime(2026, 7, 12, 10),
    );

    expect(await store.updateIntake(updated), isTrue);
    expect(store.records.single.drinkType, DrinkType.tea);
    expect(store.records.single.volumeMl, 360);

    await HydrationStore.init();
    final reloaded = HydrationStore.of().records.single;
    expect(reloaded.id, original.id);
    expect(reloaded.drinkType, DrinkType.tea);
    expect(reloaded.volumeMl, 360);
    expect(reloaded.recordedAt, DateTime(2026, 7, 12, 10));
  });

  test('deletes an intake record and persists the removal', () async {
    final store = HydrationStore.of();
    await store.addIntake(
      drinkType: DrinkType.water,
      volumeMl: 240,
      at: DateTime(2026, 7, 12, 8),
    );

    final id = store.records.single.id;

    expect(await store.deleteIntake(id), isTrue);
    expect(store.records, isEmpty);

    await HydrationStore.init();
    expect(HydrationStore.of().records, isEmpty);
  });
}
