# 竞品还原基准 — 轻补水 vs Water Tracker

竞品：[Water Tracker: Water Reminder](https://play.google.com/store/apps/details?id=watertracker.waterreminder.watertrackerapp.drinkwater)

## 策略变更（Pivot）

| 原策略 | 现策略 |
|--------|--------|
| Material3 差异化 UI | **1:1 视觉对标** |
| 预设按钮为主交互 | **滑动调量为主** |
| 3 Tab 导航 | **4 Tab：Today/History/Insights/Me** |

## 还原基准截图

| 编号 | 屏 | 实现 |
|------|-----|------|
| S02 | Today | `HomeTab` |
| S04 | Slide drink | `SlideDrinkPage` |
| S01 | Add drink | `DrinkSelectPage` |
| S06 | History | `HistoryTab` |
| S07 | Mute at night | `MuteAtNightPage` |
| S05 | Onboarding | `OnboardingPage` |

## 竞品差评 → 本版对策

| 差评 | 对策 |
|------|------|
| 多饮品宣传不实 | 完整实现 S01 网格 |
| 广告侵入 | 不接入，Remove Ads 占位 |
| 全屏提醒耗电 | UI 还原，通知用标准 local notification |

## 验收

见 `docs/ACCEPTANCE_REPORT.md` — 核心 5 屏 ≥90 分。
