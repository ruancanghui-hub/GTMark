import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/week_helper.dart';

void main() {
  test('2026-5-13 为第 20 周', () {
    expect(isoWeekNumber(DateTime(2026, 5, 13)), 20);
  });
}
