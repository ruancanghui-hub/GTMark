# COMPONENT_SPEC — 组件尺寸与状态

## WaterProgressRing

| 属性 | 值 |
|------|-----|
| 外径 | 200 dp |
| 环宽 | 14 dp |
| 轨道色 | `wtBlueLight` 40% |
| 进度色 | `wtWhite` |
| 中心 | 百分比 `NN%` + 下方 `X out of Yoz` |

状态：`progress` 0.0–1.0 动画 300ms。

## SlideToDrink

| 属性 | 值 |
|------|-----|
| 杯高 | 320 dp |
| 杯宽顶 | 160 dp |
| 杯宽底 | 120 dp |
| 手柄 | 直径 56 dp，`wtGreenHandle` |
| 刻度 | 每 4 oz 一条白线 |

状态：idle / dragging / confirming

## WtDrinkButton

| 属性 | 值 |
|------|-----|
| 高 | 52 dp |
| 圆角 | 26 |
| 文案 | `+ DRINK` 全大写 |
| 变体 | white（首页）/ gradient（slide） |

## WtBottomNav

| 属性 | 值 |
|------|-----|
| 高 | 64 + safeArea |
| 背景 | `wtBlueDark` |
| 图标 | 24 dp |
| 标签 | 11 sp |

## DrinkGridItem

| 属性 | 值 |
|------|-----|
| 列数 | 3 |
| 图标区 | 64×64 |
| 间距 | 12 |

## StatsLineChart (fl_chart)

| 属性 | 值 |
|------|-----|
| 线色 | white |
| 填充 | white 10%→0% |
| 目标虚线 | white 50% dash |
| 柱宽 (Day/Week) | 16 |

## HistoryListItem

| 属性 | 值 |
|------|-----|
| 高 | 48 |
| 左 | `N oz` w700 |
| 右 | `HH:mm` |

## OnboardingProfileCard

| 属性 | 值 |
|------|-----|
| 圆角 | 20 |
| 背景 | white 15% |
| 最小高 | 100 |

## MuteTimeWheel

| 属性 | 值 |
|------|-----|
| 选中条高 | 48 |
| 字号选中 | 32 w700 |
| 未选中 | 24 40% opacity |
