# 技术调研 — 轻补水

> 阶段 2 产出 | DeerFlow 降级：cursor-research（基于 Brief + 模板栈分析）

## 选型结论

| 项 | 选择 | 理由 |
|----|------|------|
| 跨平台框架 | **Flutter** | 工程已有 `source/src` 成熟模板；iOS/Android 一套代码 |
| 状态/路由 | **flutter_modular + get** | 与模板一致，模块边界清晰 |
| 本地存储 | **Hive** | 模板已用；补水记录适合 Box 存储 |
| UI | **tdesign_flutter** | 模板已集成，白领审美统一 |
| 图表 | **fl_chart** | 轻量、MIT、社区活跃 |
| 云同步 | **Supabase**（V2） | 模板已有 `supabase_flutter` 与 `supabase_env` 模式 |
| 提醒 | **flutter_local_notifications**（V2） | 模板 `NotificationService` 可复用 |
| AI | **DeepSeek HTTP**（V2） | 项目 `.env` 已配置 `DEEPSEEK_API_KEY` |

## Flutter vs React Native

- 模板栈已是 Flutter，无切换收益
- Hive/Modular 生态在现有代码库已验证

## 饮水目标公式（V1）

```
基础 ml = 体重(kg) × 35
活动量系数：低 1.0 / 中 1.1 / 高 1.2
每日目标 = round(基础 × 系数)，限制 [1500, 4000]
```

V2 AI 在基础目标上乘以因子：运动 +10–20%、高温 +10%、生理期 +5%（可配置）。

## Hive Box 设计

| Box | 类型 | 内容 |
|-----|------|------|
| `user_profile` | Map | 体重、活动量、目标、引导完成 |
| `intake_records` | List JSON | 每条：id, time, drinkType, volumeMl, note |
| `settings` | Map | unit, themeMode |

## 依赖清单（pubspec）

```yaml
flutter_modular: ^6.4.1
get: ^4.7.2
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.5.3
tdesign_flutter: ^0.2.7
fl_chart: ^0.70.2
intl: ^0.20.2
uuid: ^4.5.1
```

## 风险与备选

| 风险 | 缓解 |
|------|------|
| tdesign 与 Flutter 新版本兼容 | 锁定模板已验证版本 |
| 图表性能 | 月视图聚合为日总量，限制数据点 |
| Supabase 未配置 | V1 纯本地，同步 V2 |
| AI 离线 | V2 本地规则引擎降级 |

## 竞品技术启示

Water Tracker 提醒常亮问题 → V2 仅用 `flutter_local_notifications`，禁用全屏 Activity 式提醒。
