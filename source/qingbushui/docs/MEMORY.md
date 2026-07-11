# 轻补水 — 项目记忆

> 阶段 4–5 | gtmark-project-pipeline

## Pivot 记录（2026-07-11）

**目标已从「差异化 Material3 UI」改为 Water Tracker 1:1 还原。**

- Presentation 层全部重做；`core/hydration` 保留
- 调研：`docs/research/water-tracker/`（S01–S08 截图 + feature-inventory）
- 规格：`UI_SPEC`、`SCREEN_MAP`、`INTERACTION_SPEC`、`COMPONENT_SPEC`、`FIDELITY_CHECKLIST`
- 验收：`ACCEPTANCE_REPORT.md` 核心 5 屏 ≥90

## summary

轻补水 wt-clone：Flutter 对标 Water Tracker，四 Tab 导航、滑动加水、饮品网格、统计、提醒静音、Insights 静态卡。

## decisions

- **UI**：竞品蓝渐变 + CustomPainter 玻璃杯/进度环；`useMaterial3: false`
- **交互**：滑动调量为主；首页保留 16/20 oz 快捷钮
- **存储**：SharedPreferences；默认单位 oz
- **提醒**：UI 还原；实现禁用全屏常亮，仅标准通知
- **不做**：广告 SDK、内购（Me 占位）

## Ruflo keys

- `gtmark/轻补水/wt-clone/spec`
- `gtmark/轻补水/wt-clone/fidelity-score`

## Letta

目标记忆：「轻补水 advisor — 项目定位为 Water Tracker 1:1 还原，非差异化。」（Letta 无写接口时以本文档 + Ruflo 为准）

## 续作口令

「恢复轻补水 wt-clone，查阅 ACCEPTANCE_REPORT 差距项」
