# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **里程碑徽章**：`MilestonePage` 事件卡片在距离恰好为标准里程碑值（7/30/100/365天等）时显示徽章提示 (`feat(milestone): show milestone badge when event hits standard milestone`)

---

## [1.0.0+3] - 2026-05-10 (Current Release)

> 对应 `pubspec.yaml` version: `1.0.0+3`

### Added

- **搜索功能**：首页事件列表支持搜索过滤 (`feat(dashboard): add search functionality to event list`)
- **颜色选择器**：事件创建/编辑表单支持选择自定义颜色 (`feat(event): add color picker to EventFormPage`)
- **里程碑计算**：新增 `calculateMilestone` 和 `milestoneReached` 函数，支持百日/周年等里程碑提示 (`feat(day_calculator): implement calculateMilestone and milestoneReached functions`)
- **里程碑控制器**：`MilestoneController` 独立模块，支撑里程碑视图 (`refactor(milestone): extract MilestoneController + Module`)
- **测试覆盖**：DaysMatterController 单元测试、`EventFormReminderSection` widget 测试、DayEvent 模型冒烟测试 (`test(controller): add DaysMatterController unit tests`, `test(event_reminder_section): add widget tests for EventFormReminderSection`, `test(widget_test): replace placeholder with core model smoke tests`)

### Fixed

- **表单重复提交防护**：保存进行中禁用按钮，防止多次触发 (`fix(event_form): add save-in-progress guard to prevent double-submit`)
- **月/年提醒按钮缺失**：提醒类型选择器补全「每月」「每年」选项 (`fix(event_reminder_section): add missing monthly/yearly reminder type buttons`)
- **历史事件显示**：已过期的倒数事件显示已过去天数而非 0 (`fix: show elapsed days for past countdown events + extract parseHex to AppUtils`)
- **Navigator 异步 gap**：`EventFormReminderSection` 中 `Navigator.of` 异步调用前正确持有 context 引用 (`refactor(event_reminder_section): 修复 Navigator.of 异步 gap + 清理 setter 返回类型`)
- **分类下拉文本溢出**：修复分类选择器文本过长导致的溢出问题 (`fix: dropdown category text overflow`)
- **里程碑分段标签对齐**：修正里程碑视图分区标签与实际距离区间的对应关系 (`fix(milestone): align l10n section label with actual bucket range`)
- **里程碑文案硬编码**：使用本地化字符串替代硬编码英文 ("milestone reached!") (`fix(i18n): use localized milestoneReached string instead of hardcoded English`)
- **Reminder/CalendarGateAction 命名**：修正已弃用的私有类型名称引用 (`fix(event_form): rename stale _ReminderGateAction/_CalendarGateAction → ReminderGateAction/CalendarGateAction`)
- **表单解析稳定性**：消除双重否定 `!!` 空安全操作，提升提醒数据解析健壮性 (`fix(event_form): eliminate double-bang null safety in reminder parsing`)
- **表单 Column 子节点语法错误**：修复第 1083 行 Column children list 未闭合导致的解析错误 (`fix(event_form): close Column children list — resolve parse error at line 1083`)
- **Navigator.pop context bug**：修复 `pop` 时 context 已失效导致的异步回调签名问题 (`fix(event_form): Navigator.pop context bug and async callback signatures`)
- **宽屏响应式布局**：修复 iPad / Mac 宽度下的布局截断与溢出问题 (`fix(ui): responsive wide-screen layout improvements`)

### Changed

- **历史今天 Tab**：替换外部 `picsum.photos` 随机图为本地渐变背景 (`fix(main): replace external picsum.photos with local gradient in History tab`)
- **里程碑页面图标**：所有原始 emoji 替换为统一 Material Icons，提升跨平台一致性 (`fix(ui): replace raw emoji with Material Icons in milestone_page`, `refactor(ui): replace emoji with Material Icons for category visuals`)
- **Category 颜色回退**：从 DayEvent 模型中移除 emoji 字符串依赖，改为纯色回退 (`refactor(day_event): eliminate emoji strings from category fallback`)
- **主页模块化**：将约 1800 行 `main_page.dart` 拆分为 5 个独立 Tab 组件，提升可维护性 (`refactor(main): split ~1800-line main_page.dart into 5 focused tab components`)
- **ReminderSection 提取**：将提醒/日历 UI 抽取为独立 `EventFormReminderSection` 组件 (`refactor(event_form): extract reminder/calendar UI into EventFormReminderSection`)
- **分析器优化**：排除参考工程目录，避免干扰主项目静态分析 (`refactor(analyzer): exclude reference project from analysis`)

### Removed

- **废弃 MainController**：移除已不使用的 `MainController` 死代码 (`chore: remove unused MainController (dead code)`)
- **未使用 import**：清理 main 模块中 4 个未引用的 import (`refactor(main): 移除 4 个未使用的 import`)

### Chores

- **本地化字符串补全**：将 Dashboard 和 History Tab 相关字符串回填至 ARB 文件 (`chore(l10n): backfill dashboard/history strings to ARB`)
- **测试日期动态化**：将硬编码 `2026-04-28` 日期替换为动态 UTC 午夜，测试更稳定 (`fix(tests): replace hardcoded 2026-04-28 dates with dynamic UTC midnight`)
- **Mock 本地化完善**：补全 `MockAppLocalizations` 所有接口成员，测试编译更可靠 (`fix(tests): complete MockAppLocalizations with all interface members`)
- **测试基础设施**：清理 `day_calculator_test.dart` 中冗余 mock 成员 (`refactor(tests): 清理 day_calculator_test.dart 冗余 mock 成员`)

---

## [1.0.0] - 2026-04-17 (Initial Release)

> 首发版本 — 对应 `pubspec.yaml` version: `1.0.0`

### Added

- 事件创建、编辑、删除与分类展示
- 公历 / 农历日期选择与卡片详情对照
- 倒数日与正计时双模式，列表按日期智能排序
- 提醒设置与日期计算基础能力
- 法律同意门闸与中英双语法律文档
- 双语数据展示、系统权限本地化与设置页语言切换
- 登录可选，未登录亦可使用主页
- 闪屏引导与 iOS 快速打包（Fastlane）
- 日历导出（ICS）支持
- VIP 内购（服务端验单）支持

[1.0.0+3]: https://github.com/kingelf_night/flutter-app/compare/1.0.0版本...HEAD
[1.0.0]: https://github.com/kingelf_night/flutter-app/tree/1.0.0版本
