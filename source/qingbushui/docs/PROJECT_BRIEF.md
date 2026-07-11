# PROJECT_BRIEF — 轻补水（Water Tracker 1:1 还原）

> 阶段 1 产出 | gtmark-project-pipeline 修订版

## 元信息

| 字段 | 值 |
|------|-----|
| 项目名 | 轻补水 (QingBuShui) |
| 类型 | Water Tracker 视觉+核心功能 1:1 克隆 |
| 平台 | iOS + Android（Flutter） |
| 对标 | [Water Tracker](https://play.google.com/store/apps/details?id=watertracker.waterreminder.watertrackerapp.drinkwater) |
| 包名 | `qingbushui` |

## 目标

在保留 `core/hydration` 领域层前提下，将 Presentation 层完全对标竞品：蓝渐变 Today 屏、滑动加水、饮品网格、Day/Week/Month 统计、提醒+夜间静音、四 Tab 导航。

**验收**：核心 5 屏 `FIDELITY_CHECKLIST` 各 ≥90 分（见 `ACCEPTANCE_REPORT.md`）。

## 范围（In Scope）

1. 新手引导：性别/体重/运动/气候 → 计算目标（S05）
2. 首页：进度环、快捷 oz、+DRINK（S02）
3. 滑动加水 + 饮品选择（S04/S01）
4. History：日周月图表+列表（S06）
5. Insights：静态科普卡片（S08）
6. Me：单位、目标、提醒、Mute at night（S07）
7. 提醒设置 UI（标准通知，禁用全屏常亮）

## 非目标

- 广告 SDK、内购（Me 页占位说明）
- 真实 Insights CMS 后端
- 修改 `source/src` 万年历模板

## 验收标准

1. `flutter test` 全通过
2. `ACCEPTANCE_REPORT.md` 核心屏 ≥90
3. 文档齐全：`UI_SPEC`、`SCREEN_MAP`、`COMPONENT_SPEC`、`FIDELITY_CHECKLIST`
