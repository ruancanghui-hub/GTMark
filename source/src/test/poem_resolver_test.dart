import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar/lunar.dart';
import 'package:lianji/core/content/blessing_resolver.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';
import 'package:lianji/core/prefs/jichen_prefs.dart';

DateTime _solarFromLunar(int year, int month, int day) {
  final s = Lunar.fromYmd(year, month, day).getSolar();
  return DateTime(s.getYear(), s.getMonth(), s.getDay());
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init();
  });

  group('PoemResolver', () {
    setUp(PoemResolver.debugResetCaches);

    test('端午 → tf_duanwu', () {
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 6, 19)), 'tf_duanwu');
    });

    test('春节 → tf_chunjie', () {
      expect(
        PoemResolver.resolveIdForDate(_solarFromLunar(2026, 1, 1)),
        'tf_chunjie',
      );
    });

    test('除夕 → tf_chuxi', () {
      final chunjie = _solarFromLunar(2026, 1, 1);
      expect(
        PoemResolver.resolveIdForDate(
          chunjie.subtract(const Duration(days: 1)),
        ),
        'tf_chuxi',
      );
    });

    test('清明节气日 → tf_qingming 优先于 st_qingming', () {
      final id = PoemResolver.resolveIdForDate(DateTime(2026, 4, 5));
      expect(id, 'tf_qingming');
    });

    test('普通节气日 → st_*', () {
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 2, 4)), 'st_lichun');
    });

    test('劳动节 → md_labor', () {
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 5, 1)), 'md_labor');
    });

    test('上巳 → tf_shangsi', () {
      expect(
        PoemResolver.resolveIdForDate(_solarFromLunar(2026, 3, 3)),
        'tf_shangsi',
      );
    });

    test('北方小年仅廿三', () {
      JichenPrefs.xiaonianRegion = XiaonianRegion.north;
      final d23 = _solarFromLunar(2026, 12, 23);
      final d24 = _solarFromLunar(2026, 12, 24);
      expect(PoemResolver.resolveIdForDate(d23), 'tf_xiaonian');
      expect(PoemResolver.xiaonianDisplayName(d23), '北方小年');
      expect(PoemResolver.resolveIdForDate(d24), isNot('tf_xiaonian'));
      JichenPrefs.xiaonianRegion = XiaonianRegion.both;
    });

    test('南方小年仅廿四', () {
      JichenPrefs.xiaonianRegion = XiaonianRegion.south;
      final d24 = _solarFromLunar(2026, 12, 24);
      expect(PoemResolver.resolveIdForDate(d24), 'tf_xiaonian');
      expect(PoemResolver.xiaonianDisplayName(d24), '南方小年');
      JichenPrefs.xiaonianRegion = XiaonianRegion.both;
    });

    test('寒食为清明前1–2日', () {
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 4, 4)), 'tf_hanshi');
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 4, 3)), 'tf_hanshi');
      expect(
        PoemResolver.resolveIdForDate(DateTime(2026, 4, 5)),
        'tf_qingming',
      );
    });

    test('节气缓存不改变清明、寒食、小年和普通节日解析', () {
      JichenPrefs.xiaonianRegion = XiaonianRegion.north;
      final northXiaonian = _solarFromLunar(2026, 12, 23);

      expect(
        PoemResolver.resolveIdForDate(DateTime(2026, 4, 5)),
        'tf_qingming',
      );
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 4, 4)), 'tf_hanshi');
      expect(PoemResolver.resolveIdForDate(northXiaonian), 'tf_xiaonian');
      expect(PoemResolver.resolveIdForDate(DateTime(2026, 5, 1)), 'md_labor');

      JichenPrefs.xiaonianRegion = XiaonianRegion.both;
    });
  });

  group('BlessingResolver coverage', () {
    test('上巳有专属 bls_tf_shangsi', () {
      expect(BlessingResolver.forFestivalId('tf_shangsi'), isNotNull);
    });

    test('儿童节有 bls_md_children', () {
      expect(BlessingResolver.forFestivalId('md_children'), isNotNull);
    });

    test('倒数日 bls_cd_*', () {
      expect(BlessingResolver.forCountdownTheme('time'), isNotNull);
      expect(BlessingResolver.forCountdownTheme('travel'), isNotNull);
      expect(BlessingResolver.forCountdownTheme('exam'), isNotNull);
    });
  });

  group('Blessing char limit', () {
    test('超长称呼截断至 maxChars', () {
      final t = BlessingResolver.generic();
      final longName = '张' * 30;
      final text = BlessingResolver.render(
        template: t,
        useSms: false,
        chengHu: longName,
        festivalName: '佳节',
      );
      expect(text.characters.length, lessThanOrEqualTo(t.wechat.maxChars));
    });
  });
}
