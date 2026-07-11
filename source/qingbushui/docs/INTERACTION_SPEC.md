# INTERACTION_SPEC — 交互规格

## 1. 滑动加水 (S04)

| 属性 | 值 |
|------|-----|
| 手势 | 垂直 PanUpdate on 绿色手柄 |
| 范围 | 1–32 oz（步进 1 oz） |
| 反馈 | 液面高度 + 顶部数字同步 |
| 确认 | 点击「+ DRINK」→ `HydrationStore.addIntake` → pop |
| 容器 | 默认 Standard Glass，可选 bottle |

## 2. 饮品选择 (S01)

| 属性 | 值 |
|------|-----|
| 点击项 | 携带 `DrinkPreset(type, oz)` → 导航 `/drink/slide?oz=N` |
| 返回 | 系统返回箭头 |

## 3. 首页快捷 (S02)

| 属性 | 值 |
|------|-----|
| 16/20 oz 按钮 | 直接 `addIntake` + SnackBar |
| + DRINK | push `/drink/select` |
| 进度环 | 只读，`todayTotal / dailyGoal` |

## 4. 统计 Tab (S06)

| Tab | 图表 | 列表 |
|-----|------|------|
| Day | 单柱 | 当日条目 |
| Week | 7 柱 | 近 7 日分组 |
| Month | 折线 + 填充 | 按月日分组 |

切换 Tab → `setState` 重算数据。

## 5. 提醒

| 交互 | 行为 |
|------|------|
| 时段开关 | Toggle → 本地 prefs |
| Mute at night | push `/reminders/mute` |
| 时间滚轮 | 小时:分钟，Save → 持久化 |
| 通知 | **仅** `flutter_local_notifications` 调度 |

## 6. 引导 (S05)

| 卡片 | 交互 |
|------|------|
| Gender | tap 切换 Male/Female |
| Weight | tap 弹出滚轮/滑块 |
| Exercises | tap 循环 low/medium/high |
| Cold/Climate | tap 循环 cold/mild/hot |
| Calculate | 重算 goal → saveProfile → navigate main |

## 7. 底栏

- 固定 4 Tab，选中项白色高亮 + 标签
- 未选中：70% 透明度
