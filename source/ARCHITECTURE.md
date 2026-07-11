# 吉辰万年历 · `source/` 架构保留清单

状态：v0.1  
最后更新：2026-06-21  
用途：从链记模板 fork 为吉辰万年历时，**只保留架构与日历相关能力**；链记业务代码在 Phase 0 开发前批量移除，开发前以本文为准。

> **当前状态**：链记静态资源已删除（IP 插画、平台图标、启动大图、历史上的今天缓存）。  
> 链记业务 **代码模块尚未删除**——讨论闭环详规通过后再做代码剥离，避免半成品不可编译。

---

## 1. 保留（架构 + 万年历可复用）

### 1.1 工程骨架

| 路径 | 用途 |
|---|---|
| `lib/main.dart` | 入口 |
| `lib/bootstrap/` | 启动引导（Phase 0 精简：去广告/链记 Repository） |
| `lib/app/` | `AppModule`、`AppWidget`、路由 |
| `lib/shared/theme/lianji_typography.dart` | **保留字号体系**，Phase 0 重命名为吉辰 Typography |
| `lib/shared/theme/design_tokens.dart` | 保留 spacing/radius 数值，色彩覆写 |
| `lib/shared/ui/permission_prompt_dialog.dart` | 权限弹窗 |
| `lib/shared/ui/fd_nav_bar_back.dart` | 导航返回 |
| `lib/shared/utils/` | 通用工具（按需精简） |

### 1.2 日期与农历

| 路径 | 用途 |
|---|---|
| `lib/core/date/lunar_helper.dart` | 公农历转换 |
| `lib/core/date/day_calculator.dart` | 日期间隔、倒数 |
| `lib/core/date/timezone_bootstrap.dart` | 时区 |
| `lib/widgets/lunar_date_picker_dialog.dart` | 农历日期选择 |
| `lib/modules/date_calculator/` | 日期计算页（可并入工具或隐藏） |
| 依赖 `lunar: ^1.7.8` | 农历节气干支 |

### 1.3 提醒与纪念日（链记称「事件」，吉辰称「提醒/纪念日」）

| 路径 | 用途 |
|---|---|
| `lib/infra/repositories/models/day_event.dart` | 提醒数据模型（Phase 0 字段对齐吉辰） |
| `lib/infra/repositories/day_events_repository.dart` | Hive 持久化 |
| `lib/modules/event/` | 表单、详情、提醒区 |
| `lib/modules/days_matter/days_matter_controller.dart` | 列表与倒数逻辑 |
| `lib/core/services/notification_service.dart` | 本地通知 |
| `lib/core/services/builtin_holiday_events_service.dart` | 内置节日 |
| `lib/core/deadline/` | 提醒节奏模板 |
| `lib/modules/profile/event_export.dart` | 导出导入骨架 |
| 依赖 `hive`、`flutter_local_notifications`、`timezone` | 本地存储与通知 |

### 1.4 基础设施

| 路径 | 用途 |
|---|---|
| `lib/infra/storage/hive_init.dart` | Hive 初始化 |
| `lib/infra/storage/hive_constants.dart` | Box 名称 |
| `lib/core/locale/` | 国际化 holder |
| `lib/l10n/` | ARB（Phase 0 清空链记文案，写吉辰文案） |
| `lib/modules/legal/` | 隐私协议门 |
| `lib/modules/splash/` | 启动页（Phase 0 去视频预加载） |
| `lib/modules/not_found/` | 404 |
| `assets/legal/` | 隐私/条款（Phase 0 改写为吉辰） |
| `assets/images/icons/` | App 图标（Phase 0 换吉辰图标） |

### 1.6 离线内容双库（吉辰新增 · Phase 0）

| 路径 | 用途 |
|---|---|
| `assets/content/jichen_poems.v1.json` | 诗句库：节气/节日/个人场景 |
| `assets/content/jichen_blessings.v1.json` | 祝福库：微信/短信双轨模板 |
| `assets/content/figures/` | 人物章 SVG（可选） |
| `lib/core/content/content_repository.dart` | 启动加载、内存索引、离线 lookup |
| `lib/core/content/poem_resolver.dart` | 日期/事项 → 诗句 ID |
| `lib/core/content/blessing_resolver.dart` | 事项/节日 → 祝福 ID |

规格：[`设计文档/吉辰万年历-离线内容库.md`](../设计文档/吉辰万年历-离线内容库.md)

### 1.7 架构依赖（pubspec 保留）

```
flutter_modular, get, hive, hive_flutter, shared_preferences
lunar, intl, flutter_localizations
flutter_local_notifications, timezone, flutter_timezone
permission_handler, path_provider, uuid
google_fonts, flutter_screenutil
url_launcher, share_plus（P1 分享卡片）
```

---

## 2. Phase 0 移除（链记业务代码）

以下目录/文件在**闭环详规评审通过、进入开发后**整包删除，并清理 `app_module.dart`、`app_bootstrap.dart` 中的注册与路由。

### 2.1 业务模块

```
lib/modules/chain/
lib/modules/chain_learn/
lib/modules/fragment/
lib/modules/share/          # 链记分享保存，非吉辰日期分享
lib/modules/achievement/
lib/modules/milestone/
lib/modules/ads/
lib/modules/login/            # 吉辰 MVP 无账号
lib/modules/main/tabs/        # 链记四 Tab，替换为吉辰四 Tab
lib/modules/main/history_tab.dart
lib/modules/main/dashboard_tab.dart
lib/modules/main/categories_tab.dart
lib/modules/main/profile_tab.dart
lib/modules/today/today_summary_page.dart  # 链记今日摘要，非吉辰今日页
```

### 2.2 领域与数据

```
lib/domain/models/chain*.dart, fragment*.dart, study*.dart, collector*.dart, badge*.dart, platform.dart
lib/domain/repositories/chain_repository.dart, fragment_repository.dart, study_session_repository.dart
lib/infra/repositories/impl/hive_chain_repository.dart
lib/infra/repositories/impl/hive_fragment_repository.dart
lib/infra/repositories/impl/hive_study_session_repository.dart
lib/infra/storage/adapters/chain*.dart, fragment*.dart, learn_status*.dart, study_session*.dart
lib/infra/storage/demo_seed.dart   # 链记演示数据
lib/infra/network/                 # 链记用户 API（吉辰 MVP 无后端）
```

### 2.3 链记服务

```
lib/core/services/fragment_learn_service.dart
lib/core/services/study_stats_service.dart
lib/core/services/default_chain_service.dart
lib/core/services/collector_*.dart
lib/core/services/check_in_service.dart
lib/core/services/vip_service.dart, iap_service.dart
lib/core/services/incoming_share_coordinator.dart, clipboard_link_coordinator.dart
lib/core/services/link_metadata_service.dart, share_image_store.dart
lib/core/services/image_ocr_*.dart
lib/core/services/history_of_today_service.dart
lib/core/ads/
lib/core/auth/
lib/core/share/share_url_extractor.dart
lib/core/today/today_summary.dart
```

### 2.4 链记 UI 组件

```
lib/shared/widgets/lianji_*.dart（除 typography 外）
lib/shared/widgets/collector_*.dart
lib/shared/widgets/fragment_cover_background.dart
lib/shared/widgets/study_note_sheet.dart
lib/shared/ui/kling_calendar_video_loader.dart
lib/shared/ui/fd_side_panel.dart, fd_shell_nav.dart
lib/shared/theme/lianji_tokens.dart, lianji_theme.dart, lianji_layout.dart
lib/modules/splash/splash_video_preloader.dart
lib/modules/profile/lianji_*.dart
```

### 2.5 链记测试

```
test/study_stats_service_test.dart
test/share_url_extractor_test.dart
test/milestone_controller_test.dart
test/collector_progress_service_test.dart
test/chain_quota_service_test.dart
test/ad_app_open_service_test.dart
test/today_summary_test.dart
test/home_widget_pick_test.dart
```

### 2.6 可移除依赖（Phase 0 从 pubspec 删除）

```
supabase_flutter, google_mobile_ads, in_app_purchase
google_mlkit_text_recognition, video_player, receive_sharing_intent
home_widget（P1 再加）, html, flutter_markdown, flutter_image_compress
dio + cookie（无后端 MVP 不需要）
```

---

## 3. 已删除的静态资源（2026-06-21）

| 已删 | 说明 |
|---|---|
| `assets/images/lianji/` | IP、Tab 头图、装饰链、场景背景 |
| `assets/images/platform_icons/` | 链记链接平台图标 |
| `assets/images/vector/` | 装饰 SVG |
| `assets/images/lanuch.png` | 链记启动大图 |
| `assets/history/` | 历史上的今天 fallback |

---

## 4. 开发门禁

**进入 Phase 0 代码改造前必须满足：**

1. [`设计文档/吉辰万年历-闭环详规.md`](../设计文档/吉辰万年历-闭环详规.md) 评审通过
2. 五条典型场景旅程（搬家/祭扫/订婚/生日/纪念日）逐步验收表无「待定」
3. 择吉规则口径（宜忌映射、无结果策略）产品确认
4. 用户确认「忘 / 错 / 散」三条产品承诺
