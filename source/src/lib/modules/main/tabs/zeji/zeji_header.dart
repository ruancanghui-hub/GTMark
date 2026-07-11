import 'package:flutter/material.dart';

import '../../../../shared/theme/jichen_tokens.dart';
import '../../../../shared/ui/jichen_section_title.dart';

/// 择吉页白底 IP Hero。
class ZejiHeader extends StatelessWidget {
  const ZejiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: Text(
              '择吉',
              style: context.jichenTitle2().copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            left: 6,
            top: 126,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选个合适的日子',
                  style: context.jichenTitle2().copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text('趋吉避凶，事半功倍', style: context.jichenCaption()),
              ],
            ),
          ),
          Positioned(
            right: -12,
            top: 22,
            child: Image.asset(
              'assets/images/brand/ip_deer.png',
              width: 178,
              height: 190,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

/// 区块标题（左侧红条）。
typedef ZejiSectionTitle = JichenSectionTitle;

class ZejiHelpHint extends StatelessWidget {
  const ZejiHelpHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: context.jichenCaption()),
        const SizedBox(width: 4),
        Icon(
          Icons.help_outline,
          size: 16,
          color: JichenTokens.labelSecondary.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}
