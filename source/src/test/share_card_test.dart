import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_entry.dart';
import 'package:lianji/modules/share/share_card_args.dart';
import 'package:lianji/modules/share/share_card_model.dart';

const _duanwuPoems = '''
{
  "version": 1,
  "festivals": {
    "tf_duanwu": {
      "name": "端午节",
      "category": "traditional",
      "tone": "festive",
      "figure": {"name": "屈原", "era": "战国"},
      "poems": [
        {
          "id": "tf_duanwu-01",
          "text": "路漫漫其修远兮，吾将上下而求索。",
          "author": "屈原",
          "default": true
        },
        {
          "id": "tf_duanwu-02",
          "text": "节分端午自谁言，万古传闻为屈原。",
          "author": "文天祥",
          "default": false
        }
      ]
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
      poemsJson: _duanwuPoems,
      blessingsJson: '{"version":1,"templates":{}}',
    );
  });

  test('ShareCardModel cycles poem within same festival', () {
    final bundle = ContentRepository.instance.poemForFestivalId('tf_duanwu')!;
    var model = ShareCardModel(
      date: DateTime(2026, 6, 19),
      kind: ShareCardKind.dateDetail,
      headline: '端午节',
      solarLine: '2026年6月19日',
      lunarLine: '农历',
      weekday: '周五',
      poemBundle: bundle,
    );
    expect(model.activePoem?.id, 'tf_duanwu-01');
    model = model.copyWith(poemIndex: 1);
    expect(model.activePoem?.id, 'tf_duanwu-02');
    model = model.copyWith(poemIndex: 2);
    expect(model.activePoem?.id, 'tf_duanwu-01');
  });

  test('ShareCardArgs.zeji builds plain text with reason', () {
    final model = ShareCardModel.fromArgs(
      ShareCardArgs.zeji(
        date: DateTime(2026, 8, 8),
        matterName: '搬家',
        reason: '宜移徙、入宅',
        yiLabels: ['移徙', '入宅'],
      ),
    );
    final text = model.buildPlainTextShare();
    expect(text, contains('搬家'));
    expect(text, contains('宜移徙'));
    expect(text, contains('吉辰万年历'));
  });

  test('canCyclePoem false when only one poem', () {
    final bundle = PoemBundle(
      id: 'x',
      name: '测试',
      category: 'test',
      tone: 'festive',
      poems: [
        const PoemEntry(
          id: 'x-1',
          text: '一句',
          author: '作者',
          isDefault: true,
        ),
      ],
    );
    final model = ShareCardModel(
      date: DateTime.now(),
      kind: ShareCardKind.dateDetail,
      headline: '测试',
      solarLine: 's',
      lunarLine: 'l',
      weekday: 'w',
      poemBundle: bundle,
    );
    expect(model.canCyclePoem, isFalse);
  });
}
