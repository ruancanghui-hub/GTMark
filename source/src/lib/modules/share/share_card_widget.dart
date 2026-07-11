import 'package:flutter/material.dart';

import '../../core/reminder/reminder_kind.dart';
import '../../shared/theme/jichen_tokens.dart';
import 'share_card_args.dart';
import 'share_card_model.dart';
import 'share_card_tone.dart';

/// 分享卡画布（喜庆 / solemn 双气质，Design-Brief §11）。
class ShareCardWidget extends StatelessWidget {
  const ShareCardWidget({
    super.key,
    required this.model,
    required this.aspect,
  });

  final ShareCardModel model;
  final ShareCardAspect aspect;

  @override
  Widget build(BuildContext context) {
    final poem = model.activePoem;
    final bundle = model.poemBundle;
    final tall = aspect == ShareCardAspect.ratio9x16;
    final palette = model.palette;

    return Container(
      width: aspect.previewWidth,
      height: aspect.previewHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.bgTop, palette.bgBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: palette.borderColor.withValues(alpha: 0.55),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              palette.watermarkIcon,
              size: 48,
              color: palette.borderColor.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, tall ? 28 : 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (model.isSolemn) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: palette.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '祭祀用语，请尊重习俗',
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.accentColor,
                      ),
                    ),
                  ),
                ],
                Text(
                  '吉辰万年历',
                  style: TextStyle(
                    fontSize: 11,
                    color: JichenTokens.labelSecondary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  model.headline,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: palette.headlineColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  model.solarLine,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: JichenTokens.labelPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${model.lunarLine} · ${model.weekday}',
                  style: TextStyle(
                    fontSize: 14,
                    color: JichenTokens.labelSecondary.withValues(alpha: 0.95),
                  ),
                ),
                if (model.daysUntil != null &&
                    model.reminderKind == ReminderKind.countdown) ...[
                  const SizedBox(height: 6),
                  Text(
                    '倒数 ${model.daysUntil} 天',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: palette.accentColor,
                    ),
                  ),
                ],
                if (model.shengXiao != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '生肖 ${model.shengXiao}',
                    style: TextStyle(
                      fontSize: 12,
                      color: JichenTokens.labelSecondary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
                if (model.kind == ShareCardKind.zeji &&
                    model.yiLabels.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: model.yiLabels
                        .take(3)
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: JichenTokens.yiBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '宜 $e',
                              style: const TextStyle(
                                fontSize: 11,
                                color: JichenTokens.yiText,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (model.zejiReason != null &&
                    model.zejiReason!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    model.zejiReason!,
                    maxLines: tall ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: JichenTokens.labelPrimary,
                      height: 1.35,
                    ),
                  ),
                ],
                if (poem != null) ...[
                  SizedBox(height: tall ? 20 : 12),
                  Text(
                    poem.text,
                    maxLines: tall ? 5 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: JichenTokens.labelPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '—— ${poem.author}',
                    style: TextStyle(
                      fontSize: 12,
                      color: JichenTokens.labelSecondary.withValues(alpha: 0.9),
                    ),
                  ),
                  if (bundle?.figureName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _FigureSeal(name: bundle!.figureName!, palette: palette),
                        const SizedBox(width: 8),
                        Text(
                          '${bundle.figureName}${bundle.figureEra != null ? ' · ${bundle.figureEra}' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            color: JichenTokens.labelSecondary.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
                if (model.blessingText != null &&
                    model.blessingText!.trim().isNotEmpty) ...[
                  SizedBox(height: tall ? 16 : 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: palette.blessingBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: palette.blessingBorder),
                    ),
                    child: Text(
                      model.blessingText!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: JichenTokens.labelPrimary,
                      ),
                    ),
                  ),
                ],
                if (model.caption != null && model.caption!.trim().isNotEmpty) ...[
                  SizedBox(height: tall ? 12 : 8),
                  Text(
                    '「${model.caption!.trim()}」',
                    maxLines: tall ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                      color: palette.accentColor,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  '吉辰万年历 · 传统文化参考',
                  style: TextStyle(
                    fontSize: 11,
                    color: JichenTokens.labelSecondary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FigureSeal extends StatelessWidget {
  const _FigureSeal({required this.name, required this.palette});

  final String name;
  final ShareCardPalette palette;

  @override
  Widget build(BuildContext context) {
    final char = name.isNotEmpty ? name.characters.first : '贤';
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: palette.sealBorder, width: 1.5),
        color: palette.sealFill,
      ),
      child: Text(
        char,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: palette.sealBorder,
        ),
      ),
    );
  }
}
