# Water Tracker 商店截图标注 (S01–S08)

来源：[Google Play](https://play.google.com/store/apps/details?id=watertracker.waterreminder.watertrackerapp.drinkwater)  
分辨率：332×592 或 592×592 PNG  
采集日期：2026-07-11

| 编号 | 文件 | 宣传标题 | 对应 App 屏 | 路由（轻补水） |
|------|------|----------|-------------|----------------|
| S01 | S01.png | Customize your cup | 饮品选择 | `/drink/select` |
| S02 | S02.png | Drink enough water for health | 今日首页 Today | `/main/` tab 0 |
| S03 | S03.png | Get timely reminders | 提醒通知样式 + 快捷加水 | `/reminders/` |
| S04 | S04.png | Adjust with one slide | 滑动调量加水 | `/drink/slide` |
| S05 | S05.png | Calculate daily intake | 引导/目标计算 | `/onboarding/` |
| S06 | S06.png | Track detailed history | 统计 History | `/main/` tab 1 |
| S07 | S07.png | Mute at night | 夜间静音设置 | `/reminders/mute` |
| S08 | S08.png | Know facts about water | Insights 资讯 | `/main/` tab 2 |

---

## S01 — Customize your cup（饮品选择）

**布局**
- AppBar：返回箭头 + 标题「Add drink」
- 分区标题：WATER / OTHER（全大写、深灰）
- 3 列网格，每项：线稿图标 + 名称 + 容量（oz）
- 底部蓝色波浪装饰（约 15% 屏高）

**WATER 区**
| 项 | 容量 |
|----|------|
| Small Glass | 6 oz |
| Standard Glass | 8 oz |
| Large Glass | 12 oz |

**OTHER 区**
| 项 | 容量 | 填充色 |
|----|------|--------|
| Tea | 6 oz | 绿 |
| Coffee | 8 oz | 棕 |
| Milk | 8 oz | 浅蓝 |
| Orange Juice | 8 oz | 橙 |
| Beer | 12 oz | 黄 |
| Cold Drink | 16 oz | 深蓝 |

---

## S02 — Today 首页

**布局**
- 全屏蓝色渐变背景（上浅下深，下半模拟水位）
- 中央：白色圆 + 环形进度（约 60%）+ 大号百分比
- 副文案：「36 out of 60oz」（已喝/目标）
- 快捷预设：两个方形蓝按钮（16.0 oz / 20.0 oz），各含水杯图标
- 主 CTA：白色胶囊「+ DRINK」（黑字）
- 底部导航 4 Tab：Today（水滴）/ History（时钟）/ Insights（文档）/ Me（人像）

**交互**
- 点击 + DRINK → 进入滑动加水或饮品选择
- 快捷按钮 → 直接记录预设容量

---

## S03 — 提醒样式

**通知 Banner（系统层）**
- 蓝渐变卡片、圆角
- 左：绿色圆 + 闹钟图标
- 文案：「It's time to drink **wake-up water**」
- 右：时间「08:00」

**App 内屏**
- 梯形水杯，波浪液面 + 气泡
- 杯内显示「6 oz」
- 底部：蓝渐变胶囊「+ DRINK」
- 左：水滴小图标；右：三点菜单

---

## S04 — 滑动调量（核心交互）

**布局**
- 白底全屏
- 顶部：大号数字「9」+ 小「oz」
- 中央：玻璃杯 CustomPainter，多层蓝色波浪液面
- 液面内：白色刻度横线
- 绿色圆形滑块（上下双箭头），垂直拖动调量
- 底部：蓝渐变「+ DRINK」

**交互**
- 垂直拖绿色手柄 → 同步液面高度与顶部数字
- 背景可见第二台手机（水瓶容器变体）

---

## S05 — 每日目标计算（引导）

**布局**
- 蓝渐变全屏
- 顶部波浪装饰 +「Your daily goal is」
- 超大「55 oz」（数字细体、单位小）
- 白色胶囊「Calculate」
- 2×2 半透明深蓝卡片：
  - Female（emoji）
  - 145 lbs
  - Exercises（柱状图图标，中柱高亮）
  - Cold（雪花图标）

---

## S06 — History 统计

**布局**
- 蓝渐变背景
- Tab：Day / Week / **Month**（下划线指示器）
- 指标：Daily Average「56.6 oz」+ Total「1755 oz」
- 折线图：白色曲线 + 渐变填充 + 虚线目标线「52 oz」
- X 轴：1,4,7…31
- 列表：日期头「Dec 31 · 62 oz」+ 圆角条目「7 oz · 18:35」

---

## S07 — Mute at night

**布局**
- 深蓝夜空渐变 + 星月装饰（屏外宣传）
- 静音铃铛图标（发光蓝圈）
- 问句：「When do you usually end a day?」
- 垂直滚轮时间选择器，选中「23 : 30」高亮条
- 底部蓝胶囊「Save」

---

## S08 — Insights

**布局**
- 白底
- 标题「INSIGHTS」全大写
- 分类区块横向滚动卡片：
  - Water Drinking（鼠尾草绿）
  - Beauty & Skincare（粉桃色）
  - Self-care（浅蓝）
- 每卡：插画 + 标题文案
