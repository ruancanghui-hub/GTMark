import 'package:flutter_test/flutter_test.dart';
import 'package:qingbushui/l10n/app_locale.dart';
import 'package:qingbushui/l10n/app_localizations.dart';
import 'package:qingbushui/l10n/insight_articles.dart';

void main() {
  test('English and Chinese strings differ for core labels', () {
    final en = AppLocalizations(AppLocale.en);
    final zh = AppLocalizations(AppLocale.zh);

    expect(en.appTitle, 'Qing Water');
    expect(zh.appTitle, '轻补水');
    expect(en.navToday, 'Today');
    expect(zh.navToday, '今日');
    expect(en.language, 'Language');
    expect(zh.language, '语言');
  });

  test('Chinese covers previously hardcoded English UI strings', () {
    final zh = AppLocalizations(AppLocale.zh);

    expect(zh.insights, '资讯');
    expect(zh.sectionWater, '水');
    expect(zh.ok, '确定');
    expect(zh.tuneAmount, '调节容量');
    expect(zh.insightArticleTitle(InsightArticle.avoidMistakes), '避免这些饮水误区');
    expect(zh.dailyRemindersStatus(2, true, true), '2 条每日提醒已就绪');
  });
}
