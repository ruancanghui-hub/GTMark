import 'package:flutter/material.dart';

import '../../../../core/zeji/zeji_matter.dart';
import '../../../../shared/theme/jichen_tokens.dart';
import 'zeji_matter_icons.dart';

/// 择吉表单白卡（事项网格 + 日期范围 + 查询按钮）。
class ZejiFormCard extends StatelessWidget {
  const ZejiFormCard({
    super.key,
    required this.matterIds,
    required this.isMatterSelected,
    required this.matterDescription,
    required this.rangePreset,
    required this.customStart,
    required this.customEnd,
    required this.weekendOnly,
    required this.loading,
    required this.onSelectMatter,
    required this.onSelectRange,
    required this.onToggleWeekendOnly,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onSearch,
  });

  final List<String> matterIds;
  final bool Function(String id) isMatterSelected;
  final String matterDescription;
  final ZejiRangePreset rangePreset;
  final DateTime customStart;
  final DateTime customEnd;
  final bool weekendOnly;
  final bool loading;
  final ValueChanged<String> onSelectMatter;
  final ValueChanged<ZejiRangePreset> onSelectRange;
  final ValueChanged<bool> onToggleWeekendOnly;
  final ValueChanged<DateTime> onPickStart;
  final ValueChanged<DateTime> onPickEnd;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final visibleMatters = ZejiMatter.all.take(6).toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: JichenTokens.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('事项', style: context.jichenBody(weight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 80,
            ),
            itemCount: visibleMatters.length,
            itemBuilder: (context, index) {
              final m = visibleMatters[index];
              return _MatterChip(
                matter: m,
                selected: isMatterSelected(m.id),
                onTap: () => onSelectMatter(m.id),
              );
            },
          ),
          const SizedBox(height: 18),
          Text('日期范围', style: context.jichenBody(weight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DateRangeBox(date: customStart, onPick: onPickStart),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('至', style: context.jichenBody()),
              ),
              Expanded(
                child: _DateRangeBox(
                  date: customEnd,
                  onPick: onPickEnd,
                  showChevron: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('筛选条件', style: context.jichenBody(weight: FontWeight.w700)),
          const SizedBox(height: 8),
          _FilterRow(
            title: '只看周末',
            trailing: Switch(
              value: weekendOnly,
              activeTrackColor: JichenTokens.accent.withValues(alpha: 0.35),
              activeThumbColor: JichenTokens.accent,
              onChanged: onToggleWeekendOnly,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: loading ? null : onSearch,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: JichenTokens.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      '让吉辰帮我选',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRangeBox extends StatelessWidget {
  const _DateRangeBox({
    required this.date,
    required this.onPick,
    this.showChevron = false,
  });

  final DateTime date;
  final ValueChanged<DateTime> onPick;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onPick(picked);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: JichenTokens.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                  style: context.jichenFootnote(
                    color: JichenTokens.labelPrimary,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.title, required this.trailing});

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: JichenTokens.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.jichenBody())),
          trailing,
        ],
      ),
    );
  }
}

class _MatterChip extends StatelessWidget {
  const _MatterChip({
    required this.matter,
    required this.selected,
    required this.onTap,
  });

  final ZejiMatter matter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? JichenTokens.accent
        : JichenTokens.labelPrimary;

    return Material(
      color: selected ? const Color(0xFFFFF0EE) : JichenTokens.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? JichenTokens.accent : JichenTokens.cardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (selected)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: JichenTokens.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: zejiMatterIconWidget(
                          matterId: matter.id,
                          selected: selected,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      matter.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
