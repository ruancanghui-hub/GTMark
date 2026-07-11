# 页面清单 — 轻补水

## 路由表

| 路由 | 页面 | 入口 | V1 |
|------|------|------|-----|
| `/splash` | 启动页 | 冷启动 | ✅ |
| `/onboarding` | 新手引导 | 首次未完成引导 | ✅ |
| `/main` | 主框架（底部 Tab） | 引导完成 / 老用户 | ✅ |
| `/main/home` | 首页 | Tab 1 | ✅ |
| `/main/stats` | 数据统计 | Tab 2 | ✅ |
| `/main/settings` | 设置 | Tab 3 | ✅ |
| `/record/add` | 添加/编辑记录 | 首页「详细记录」 | ✅ |
| `/achievements` | 勋章成就 | 设置/首页入口 | V2 |
| `/reminders` | 提醒设置 | 设置 | V2 |
| `/ai-chat` | AI 补水助手 | 首页 FAB / Tab | V2 |
| `/education` | 科普专区 | 设置 | V2 |

## 页面组件要点

### 首页 `/main/home`

- `WaterBottleProgress`：水瓶动画 + 百分比
- `TodaySummaryCard`：已喝 / 剩余 / 目标
- `QuickAddBar`：快捷容量按钮
- `TodayIntakeList`：今日记录列表

### 记录详情 `/record/add`

- `DrinkTypePicker`：饮品类型网格
- `VolumeSlider`：容量滑块 50–1000ml
- `NoteField`：备注输入
- `SaveButton`

### 统计 `/main/stats`

- `PeriodTabBar`：日 / 周 / 月
- `HydrationChart`：fl_chart 图表
- `StreakBadge`：连续打卡
- `CalendarHeatmap`：月历达标标记

### 设置 `/main/settings`

- `UnitToggle`：ml / oz
- `ThemeSelector`：浅色 / 深色 / 跟随系统
- `SyncPlaceholder`：V2 云同步入口（V1 显示「即将推出」）

## 导航关系

```
Splash → (首次?) Onboarding → Main[Home|Stats|Settings]
Home → RecordAdd → Home
Settings → (V2) Reminders / AI / Education
```
