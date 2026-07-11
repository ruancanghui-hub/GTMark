# Water Tracker — 功能清单 (Feature Inventory)

> 基于 Google Play 商店描述 + S01–S08 截图拆解（DeerFlow 等效页面分析）  
> 包名：`watertracker.waterreminder.watertrackerapp.drinkwater`  
> 开发商：QR & Barcode Scanner / 杭州励普科技  
> 体量：5M+ 下载，4.8★

## 核心模块对照

| # | 模块 | 商店宣传 | 截图证据 | 还原优先级 | 轻补水实现 |
|---|------|----------|----------|------------|------------|
| 1 | 今日首页 | 简洁 UI、进度、目标 | S02 | P0 | `HomeTab` |
| 2 | 滑动加水 | Adjust with one slide | S04 | P0 | `SlideDrinkPage` |
| 3 | 饮品选择 | Customize your cup | S01 | P0 | `DrinkSelectPage` |
| 4 | 目标计算 | 年龄体重运动天气 | S05 | P0 | `OnboardingPage` |
| 5 | 统计历史 | Day/Week/Month | S06 | P0 | `HistoryTab` |
| 6 | 智能提醒 | 时段提醒 | S03 | P0 | `ReminderSettings` |
| 7 | 夜间静音 | Mute at night | S07 | P0 | `MuteAtNightPage` |
| 8 | Insights | 饮水科普 | S08 | P1 | `InsightsTab` |
| 9 | Me/设置 | Feedback、单位、目标 | S02 底栏 | P0 | `MeTab` |
| 10 | 快捷预设 | 16/20 oz 按钮 | S02 | P0 | 首页快捷区 |

## 导航结构

```
BottomNav (4 tabs)
├── Today      → 进度环 + 快捷 + DRINK
├── History    → Day/Week/Month 统计
├── Insights   → 分类卡片横向滚动
└── Me         → 设置列表
```

子路由（非 Tab）：
- `/drink/select` — 饮品网格
- `/drink/slide` — 滑动调量
- `/onboarding/` — 多步引导
- `/reminders/mute` — 夜间静音

## 交互规格摘要

### 滑动加水 (S04)
- 垂直拖动手势，范围约 1–32 oz（推断）
- 绿色圆形手柄，液面波浪动画
- 确认：「+ DRINK」按钮写入记录

### 饮品选择 (S01)
- 点击网格项 → 带默认容量进入 slide 或直接记录
- WATER / OTHER 分区

### 统计 (S06)
- Tab 切换重绘图表类型（日柱/周柱/月折线）
- 列表按日分组，显示时间与容量

### 提醒 (S03/S07)
- 预设时段：wake-up、餐前餐后、睡前
- 夜间静音：结束时间滚轮 + Save
- **实现约束**：标准 local notification，**禁用全屏常亮**

## 数据模型扩展

| 字段 | 类型 | 说明 |
|------|------|------|
| gender | enum | male/female |
| climate | enum | cold/mild/hot |
| drinkType | enum | +milk, beer, coldDrink, orangeJuice |
| container | enum | smallGlass, standardGlass, largeGlass, bottle |
| muteEndTime | TimeOfDay | 夜间静音截止 |
| remindersEnabled | bool | 总开关 |

## 明确不做（V1）

| 项 | 处理 |
|----|------|
| 广告 SDK | Me 页占位「Remove Ads」标注跳过 |
| 内购 | 同上 |
| 真实 Insights CMS | 静态本地卡片内容 |
| 全屏唤醒提醒 | UI 还原，通知用 flutter_local_notifications |

## 验收映射

| 核心屏 | 截图 | 目标分 |
|--------|------|--------|
| 首页 | S02 | ≥90 |
| 滑动加水 | S04 | ≥90 |
| 统计 | S06 | ≥90 |
| 提醒/静音 | S03+S07 | ≥90 |
| Me | 推断 | ≥90 |
