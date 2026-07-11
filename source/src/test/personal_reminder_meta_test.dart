import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_repeat.dart';
import 'package:lianji/modules/share/share_card_args.dart';
import 'package:lianji/modules/share/share_card_model.dart';

const _personalPoems = '''
{
  "version": 1,
  "personal": {
    "bd_parent": {
      "name": "父母生日",
      "category": "personal_birthday",
      "relation": "parent",
      "tone": "festive",
      "poems": [{
        "id": "bd_parent-01",
        "text": "谁言寸草心，报得三春晖。",
        "author": "孟郊",
        "default": true
      }]
    },
    "an_wedding": {
      "name": "结婚纪念日",
      "category": "personal_anniversary",
      "subtype": "wedding",
      "tone": "festive",
      "poems": [{
        "id": "an_wedding-01",
        "text": "愿得一心人，白头不相离。",
        "author": "卓文君",
        "default": true
      }]
    }
  }
}
''';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('zh_CN');
  });

  setUp(() async {
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init(
      poemsJson: _personalPoems,
      blessingsJson: '{"version":1,"templates":{}}',
    );
  });

  test('PersonalReminder serializes SPEC-013 metadata', () {
    final r = PersonalReminder(
      id: '1',
      title: '爸爸生日',
      date: DateTime(2026, 5, 1),
      kind: ReminderKind.birthday,
      repeatRule: ReminderRepeatRule.yearlyLunar,
      birthdayRelation: 'parent',
    );
    final back = PersonalReminder.deserialize(r.serialize());
    expect(back?.birthdayRelation, 'parent');
    expect(back?.personalPoemId, 'bd_parent');
  });

  test('ShareCardArgs.fromReminder uses bd_parent poem', () {
    final r = PersonalReminder(
      id: '1',
      title: '爸爸生日',
      date: DateTime(2026, 5, 1),
      kind: ReminderKind.birthday,
      birthdayRelation: 'parent',
      repeatRule: ReminderRepeatRule.yearlyLunar,
    );
    final model = ShareCardModel.fromArgs(ShareCardArgs.fromReminder(r));
    expect(model.activePoem?.author, '孟郊');
  });

  test('ShareCardArgs.fromReminder uses an_wedding poem', () {
    final r = PersonalReminder(
      id: '2',
      title: '结婚纪念',
      date: DateTime(2020, 10, 1),
      kind: ReminderKind.anniversary,
      anniversarySubtype: 'wedding',
      repeatRule: ReminderRepeatRule.yearlySolar,
    );
    final model = ShareCardModel.fromArgs(ShareCardArgs.fromReminder(r));
    expect(model.activePoem?.text, contains('一心人'));
  });

  test('ShareCardAspect export dimensions are 1080px', () {
    expect(ShareCardAspect.ratio1x1.exportWidth, 1080);
    expect(ShareCardAspect.ratio1x1.exportHeight, 1080);
    expect(ShareCardAspect.ratio9x16.exportWidth, 1080);
    expect(ShareCardAspect.ratio9x16.exportHeight, 1920);
    expect(ShareCardAspect.ratio1x1.capturePixelRatio, 3.0);
  });

  test('PoemResolver personal ids', () {
    expect(PoemResolver.personalBirthdayId('parent'), 'bd_parent');
    expect(PoemResolver.personalAnniversaryId('wedding'), 'an_wedding');
    expect(PoemResolver.personalCountdownId('exam'), 'cd_exam');
  });
}
