import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/date_input_parser.dart';

void main() {
  test('parses yyyy-MM-dd', () {
    final d = DateInputParser.parse('2026-06-21');
    expect(d, DateTime(2026, 6, 21));
  });

  test('parses Chinese format', () {
    final d = DateInputParser.parse('2026年6月21日');
    expect(d, DateTime(2026, 6, 21));
  });

  test('rejects invalid date', () {
    expect(DateInputParser.parse('2026-13-01'), isNull);
    expect(DateInputParser.parse('abc'), isNull);
  });
}
