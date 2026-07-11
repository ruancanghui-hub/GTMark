# UI_SPEC — Water Tracker 1:1 还原设计令牌

> 基准截图：S01–S08 | 应用名：轻补水 | 默认单位：oz

## 色板

| Token | Hex | 用途 |
|-------|-----|------|
| `wtBlueLight` | `#4FC3F7` | 渐变顶、浅水位 |
| `wtBlueMid` | `#1E88E5` | 主色、按钮渐变左 |
| `wtBlueDark` | `#0D47A1` | 底栏、深水区 |
| `wtBlueDeep` | `#1565C0` | 按钮渐变右 |
| `wtGreenHandle` | `#4CAF50` | 滑动加水手柄 |
| `wtWhite` | `#FFFFFF` | 卡片、主 CTA 底 |
| `wtTextDark` | `#212121` | 白底屏主文字 |
| `wtTextMuted` | `#757575` | 分区标题 |
| `wtNotificationGreen` | `#66BB6A` | 提醒图标底 |

## 渐变

```dart
// 主背景（Today / History）
LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
  colors: [wtBlueLight, wtBlueMid, wtBlueDark])

// 主按钮 + DRINK
LinearGradient(colors: [wtBlueMid, wtBlueDeep])

// 通知 Banner
LinearGradient(colors: [wtBlueMid, wtBlueDark])
```

## 圆角

| 组件 | 半径 |
|------|------|
| 主 CTA 胶囊 | 28 |
| 快捷预设方钮 | 12 |
| 统计列表条目 | 16 |
| 引导参数卡片 | 20 |
| Insights 卡片 | 12 |

## 字号

| 用途 | 大小 | 字重 |
|------|------|------|
| 进度百分比 | 36 | w700 |
| 滑动数字 | 72 | w200 |
| 目标 oz | 48 | w200 |
| 分区标题 WATER/OTHER | 12 | w700 letterSpacing 1.2 |
| Tab 标签 | 14 | w600 |
| 列表容量 | 18 | w700 |
| 列表时间 | 14 | w400 |

## 间距

- 屏水平边距：20
- 进度环直径：200
- 底栏高度：64
- Tab 下划线高度：3

## 图标风格

- 线稿水杯 + 蓝色液体填充（饮品网格）
- 底栏：水滴 / 时钟 / 文档 / 人像
- 禁止 Material3 默认 NavigationBar 造型

## ThemeData

- `useMaterial3: false`
- `fontFamily`: 系统默认（Roboto / SF）
- `scaffoldBackgroundColor`: 按屏切换（蓝渐变或白）
