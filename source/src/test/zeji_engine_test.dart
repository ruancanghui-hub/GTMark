import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/zeji/zeji_engine.dart';
import 'package:lianji/core/zeji/zeji_matter.dart';

void main() {
  test('preset30 搬家 returns up to 3 recommendations', () {
    final q = ZejiQuery.preset30(matterId: 'MAT-01');
    final result = ZejiEngine.search(q);
    expect(result.scannedDays, 30);
    expect(result.recommendations.length, lessThanOrEqualTo(3));
    expect(result.recommendations.length, greaterThan(0));
    for (final r in result.recommendations) {
      expect(r.reason, isNotEmpty);
      expect(r.matchedYi, isNotEmpty);
    }
  });

  test('MAT-08 generic finds candidates in 7 days', () {
    final q = ZejiQuery.preset7(matterId: 'MAT-08');
    final result = ZejiEngine.search(q);
    expect(result.recommendations, isNotEmpty);
  });

  test('invalid range returns note', () {
    final q = ZejiQuery(
      matterId: 'MAT-01',
      start: DateTime(2026, 6, 21),
      end: DateTime(2026, 3, 1),
    );
    final result = ZejiEngine.search(q);
    expect(result.isEmpty, isTrue);
    expect(result.note, isNotNull);
  });

  test('skipWorkdayAdjust excludes work adjust days', () {
    final q = ZejiQuery(
      matterId: 'MAT-08',
      start: DateTime(2026, 1, 1),
      end: DateTime(2026, 1, 31),
      skipWorkdayAdjust: true,
    );
    final result = ZejiEngine.search(q);
    expect(result.recommendations.every((r) => !r.workAdjust), isTrue);
  });

  test('weekendOnly excludes weekdays', () {
    final q = ZejiQuery(
      matterId: 'MAT-08',
      start: DateTime(2026, 1, 1),
      end: DateTime(2026, 1, 31),
      weekendOnly: true,
    );
    final result = ZejiEngine.search(q);
    expect(result.recommendations, isNotEmpty);
    expect(
      result.recommendations.every(
        (r) =>
            r.date.weekday == DateTime.saturday ||
            r.date.weekday == DateTime.sunday,
      ),
      isTrue,
    );
  });

  test('validateRange rejects over 90 days', () {
    final msg = ZejiQuery.validateRange(
      DateTime(2026, 1, 1),
      DateTime(2026, 6, 1),
    );
    expect(msg, contains('90'));
  });
}
