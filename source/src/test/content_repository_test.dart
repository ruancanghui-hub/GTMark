import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/blessing_resolver.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';

const _samplePoems = '''
{
  "version": 1,
  "festivals": {
    "tf_duanwu": {
      "name": "端午节",
      "category": "traditional",
      "tone": "festive",
      "figure": {"name": "屈原", "era": "战国"},
      "poems": [{
        "id": "tf_duanwu-01",
        "text": "路漫漫其修远兮，吾将上下而求索。",
        "author": "屈原",
        "source": "离骚",
        "default": true
      }]
    }
  },
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
        "source": "游子吟",
        "default": true
      }]
    }
  }
}
''';

const _sampleBlessings = '''
{
  "version": 1,
  "templates": {
    "bls_tf_duanwu": {
      "id": "bls_tf_duanwu",
      "scene": "festival",
      "tone": "festive",
      "wechat": {"text": "{称呼}，端午安康", "maxChars": 50, "emojiAllowed": true},
      "sms": {"text": "{称呼}，端午安康，愿平安。", "maxChars": 70, "emojiAllowed": false}
    },
    "bls_generic": {
      "id": "bls_generic",
      "scene": "generic",
      "tone": "festive",
      "wechat": {"text": "{称呼}，{节日名}快乐！", "maxChars": 50, "emojiAllowed": true},
      "sms": {"text": "{称呼}，祝您{节日名}快乐。", "maxChars": 70, "emojiAllowed": false}
    }
  }
}
''';

void main() {
  setUp(() async {
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init(
      poemsJson: _samplePoems,
      blessingsJson: _sampleBlessings,
    );
  });

  test('loads offline poem and blessing counts', () {
    expect(ContentRepository.instance.poemCount, 2);
    expect(ContentRepository.instance.blessingCount, 2);
  });

  test('端午农历五月初五解析为 tf_duanwu', () {
    final id = PoemResolver.festivalIdForDate(DateTime(2026, 6, 19));
    expect(id, 'tf_duanwu');
    final poem = ContentRepository.instance.poemForFestivalId(id!);
    expect(poem?.defaultPoem.author, '屈原');
  });

  test('父亲生日解析 bd_parent 诗句', () {
    final poem = PoemResolver.resolveForBirthday(relation: 'parent');
    expect(poem?.defaultPoem.text, contains('寸草心'));
  });

  test('祝福微信版渲染', () {
    final t = BlessingResolver.forFestivalId('tf_duanwu')!;
    final text = BlessingResolver.render(
      template: t,
      useSms: false,
      chengHu: '爸爸',
    );
    expect(text, '爸爸，端午安康');
  });
}
