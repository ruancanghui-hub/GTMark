import 'package:intl/intl.dart';

import '../../core/content/blessing_resolver.dart';
import '../../core/content/content_repository.dart';
import '../../core/content/poem_entry.dart';
import '../../core/content/poem_resolver.dart';
import '../../core/date/day_info_service.dart';
import '../../core/date/lunar_helper.dart';
import '../../core/reminder/reminder_kind.dart';
import 'share_card_args.dart';
import 'share_card_tone.dart';

enum ShareCardAspect {
  ratio1x1(1, 1, '1:1'),
  ratio9x16(9, 16, '9:16');

  const ShareCardAspect(this.w, this.h, this.label);
  final int w;
  final int h;
  final String label;

  /// 导出长边像素（Design-Brief §11：1080×1080 / 1080×1920）。
  static const exportLongEdge = 1080;

  double get previewWidth => 360;
  double get previewHeight => previewWidth * h / w;

  int get exportWidth => exportLongEdge;
  int get exportHeight => (exportLongEdge * h / w).round();

  double get capturePixelRatio => exportLongEdge / previewWidth;
}

/// 分享卡渲染数据（离线诗句 + 双历）。
class ShareCardModel {
  ShareCardModel({
    required this.date,
    required this.kind,
    required this.headline,
    required this.solarLine,
    required this.lunarLine,
    required this.weekday,
    this.shengXiao,
    this.poemBundle,
    this.poemIndex = 0,
    this.blessingText,
    this.zejiReason,
    this.yiLabels = const [],
    this.daysUntil,
    this.reminderKind,
    this.caption,
    this.festivalId,
  });

  final DateTime date;
  final ShareCardKind kind;
  final String headline;
  final String solarLine;
  final String lunarLine;
  final String weekday;
  final String? shengXiao;
  final PoemBundle? poemBundle;
  final int poemIndex;
  final String? blessingText;
  final String? zejiReason;
  final List<String> yiLabels;
  final int? daysUntil;
  final ReminderKind? reminderKind;
  final String? caption;
  final String? festivalId;

  bool get isSolemn =>
      ShareCardTone.isSolemn(festivalId: festivalId, poemTone: poemBundle?.tone);

  ShareCardPalette get palette => ShareCardPalette.forModel(solemn: isSolemn);

  bool get canCyclePoem =>
      poemBundle != null && poemBundle!.poems.length > 1;

  PoemEntry? get activePoem {
    final bundle = poemBundle;
    if (bundle == null || bundle.poems.isEmpty) return null;
    return bundle.poems[poemIndex % bundle.poems.length];
  }

  ShareCardModel copyWith({int? poemIndex, String? caption}) => ShareCardModel(
        date: date,
        kind: kind,
        headline: headline,
        solarLine: solarLine,
        lunarLine: lunarLine,
        weekday: weekday,
        shengXiao: shengXiao,
        poemBundle: poemBundle,
        poemIndex: poemIndex ?? this.poemIndex,
        blessingText: blessingText,
        zejiReason: zejiReason,
        yiLabels: yiLabels,
        daysUntil: daysUntil,
        reminderKind: reminderKind,
        caption: caption ?? this.caption,
        festivalId: festivalId,
      );

  static ShareCardModel fromArgs(ShareCardArgs args) {
    final info = DayInfoService.build(args.date);
    final resolvedFestivalId = args.festivalId ??
        args.personalPoemId ??
        PoemResolver.resolveIdForDate(args.date);
    PoemBundle? bundle;
    if (args.personalPoemId != null) {
      bundle = ContentRepository.instance.poemForFestivalId(args.personalPoemId!);
    } else if (resolvedFestivalId != null) {
      bundle = ContentRepository.instance.poemForFestivalId(resolvedFestivalId);
    }
    if (bundle == null && args.kind == ShareCardKind.anniversary) {
      // 个人纪念日无诗句时不凑节日库
      bundle = null;
    } else if (bundle == null && args.kind != ShareCardKind.zeji) {
      bundle = PoemResolver.resolveForDate(args.date);
    }

    final weekday = DateFormat.E('zh_CN').format(args.date);

    String headline;
    switch (args.kind) {
      case ShareCardKind.zeji:
        headline = args.matterName ?? '择吉推荐';
      case ShareCardKind.blessing:
        headline = bundle?.name ?? info.festivalName ?? '吉辰祝福';
      case ShareCardKind.anniversary:
        headline = _anniversaryHeadline(args);
      case ShareCardKind.dateDetail:
        headline = info.festivalName ?? bundle?.name ?? '吉辰万年历';
    }

    String? blessingText = args.blessingText;
    if (blessingText == null &&
        args.kind == ShareCardKind.dateDetail &&
        resolvedFestivalId != null) {
      final template =
          ContentRepository.instance.blessingForFestivalId(resolvedFestivalId);
      if (template != null) {
        blessingText = BlessingResolver.render(
          template: template,
          useSms: false,
          chengHu: '您',
          festivalName: bundle?.name ?? info.festivalName ?? '佳节',
        );
      }
    }

    return ShareCardModel(
      date: args.date,
      kind: args.kind,
      headline: headline,
      solarLine: DateFormat('yyyy年M月d日').format(args.date),
      lunarLine: lunarLabelForSolar(args.date),
      weekday: weekday,
      shengXiao: info.shengXiao,
      poemBundle: bundle,
      blessingText: blessingText,
      zejiReason: args.zejiReason,
      yiLabels: args.yiLabels,
      daysUntil: args.daysUntil,
      reminderKind: args.reminderKind,
      caption: args.caption,
      festivalId: resolvedFestivalId,
    );
  }

  static String _anniversaryHeadline(ShareCardArgs args) {
    final title = args.matterName ?? '纪念日';
    final days = args.daysUntil;
    return switch (args.reminderKind) {
      ReminderKind.birthday => '$title · 生日',
      ReminderKind.countdown =>
        days != null ? '$title · 还有 $days 天' : title,
      ReminderKind.anniversary => title,
      ReminderKind.event || null => title,
    };
  }

  String buildPlainTextShare() {
    final buf = StringBuffer()
      ..writeln(solarLine)
      ..writeln(lunarLine)
      ..writeln(weekday);
    if (kind == ShareCardKind.zeji) {
      buf.writeln(headline);
      if (zejiReason != null) buf.writeln(zejiReason);
    } else if (zejiReason != null) {
      buf.writeln(zejiReason);
    }
    final poem = activePoem;
    if (poem != null) {
      buf.writeln(poem.text);
      buf.writeln('—— ${poem.author}');
    }
    if (blessingText != null && blessingText!.trim().isNotEmpty) {
      buf.writeln(blessingText);
    }
    if (caption != null && caption!.trim().isNotEmpty) {
      buf.writeln(caption!.trim());
    }
    buf.writeln('—— 吉辰万年历');
    return buf.toString().trim();
  }
}
