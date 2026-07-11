// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '吉辰万年历';

  @override
  String get appNameShort => '吉辰万年历';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '删除';

  @override
  String get commonAdd => '添加';

  @override
  String get commonSave => '保存';

  @override
  String get commonSubmit => '提交';

  @override
  String get commonClose => '关闭';

  @override
  String get commonOk => '确定';

  @override
  String get notFoundTitle => '页面不存在';

  @override
  String get notFoundBackHome => '回到首页';

  @override
  String get splashTagline => '查日期 · 择吉 · 提醒 · 发祝福';

  @override
  String get splashMessage => '查日期 · 择吉 · 提醒 · 发祝福，重要日子不再错过。';

  @override
  String get splashLoading => '加载中…';

  @override
  String get splashVideoUnavailable => '视频暂不可用';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionDateDisplay => '日期与显示';

  @override
  String get settingsHomeCardOrderTitle => '首页卡片主副标题顺序';

  @override
  String get settingsHomeCardOrderSubtitle => '控制公历、农历两行谁先展示';

  @override
  String get settingsSolarFirst => '公历优先';

  @override
  String get settingsLunarFirst => '农历优先';

  @override
  String get settingsSectionNotify => '通知';

  @override
  String get settingsNotifyMasterTitle => '通知总开关';

  @override
  String get settingsNotifyMasterSubtitle => '关闭后不再调度新提醒（已保存的提醒配置仍保留）';

  @override
  String get settingsSectionHabitWidget => '习惯与桌面小组件';

  @override
  String get settingsWidgetModeTitle => '小组件主展示事件';

  @override
  String get settingsWidgetModeNearest => '最近的截止日';

  @override
  String get settingsWidgetModeTodayFirst => '与「今日」列表首条一致';

  @override
  String get settingsWidgetModePinnedFirst => '7 日内置顶，否则最近截止';

  @override
  String get settingsDailyDigestTitle => '每日摘要通知';

  @override
  String get settingsDailyDigestSubtitle => '开启后每天最多一条；需打开上方通知总开关。';

  @override
  String get settingsDailyDigestTime => '摘要时间';

  @override
  String get notifDigestChannelName => '每日摘要';

  @override
  String get notifDigestChannelDescription => '在设置中开启后，每天最多一条。';

  @override
  String get notifDigestTitle => '今日';

  @override
  String notifDigestBody(int count) {
    return '未来 7 天内有 $count 个倒数。';
  }

  @override
  String get settingsSectionLegal => '法律与帮助';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsTerms => '用户协议';

  @override
  String get settingsFeedback => '意见反馈';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get settingsAboutApp => '关于 吉辰万年历';

  @override
  String settingsVersion(String version) {
    return '版本 $version';
  }

  @override
  String get settingsAboutBlurb => '重要日期管理与本地提醒。使用邮箱登录时，事件数据同步至您配置的云端服务。';

  @override
  String get settingsSectionLanguage => '语言';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get copyrightLegalese => '© 2026';

  @override
  String get navCountdownDay => '倒数日';

  @override
  String get navCountdownBook => '倒数本';

  @override
  String get navHistoryToday => '历史上的今天';

  @override
  String get navProfile => '我的';

  @override
  String get sidePanelGuest => '本地用户';

  @override
  String get sidePanelOpenSettings => '打开设置';

  @override
  String get appBarTitleDays => '吉辰万年历 · 倒数日';

  @override
  String get appBarTitleBook => '倒数本';

  @override
  String get appBarTitleHistory => '历史上的今天';

  @override
  String get appBarTitleProfile => '我的';

  @override
  String get appBarTitleDefault => '吉辰万年历';

  @override
  String appBarFiltered(String label) {
    return '吉辰万年历 · 仅 $label';
  }

  @override
  String get deleteEventTitle => '删除事件？';

  @override
  String deleteEventBody(String title) {
    return '「$title」将被永久删除。';
  }

  @override
  String get deleteCategoryTitle => '删除分类？';

  @override
  String deleteCategoryBody(String name) {
    return '将删除「$name」。仅当该分类下无事件时可删除。';
  }

  @override
  String get emptyEventsFiltered => '该分类下暂无事件，点击右上角 + 添加或切换筛选';

  @override
  String get emptyEvents => '暂无事件，点击右上角 + 添加';

  @override
  String get searchEventsHint => '搜索事件...';

  @override
  String get searchClearTooltip => '清空搜索';

  @override
  String get dashboardQuickPickAll => '全部';

  @override
  String get dashboardQuickPickSectionHint => '点选事件名称可快速筛选，下方仍可输入关键字。';

  @override
  String get dashboardSearchKeywordHint => '关键字';

  @override
  String get dashboardSearchPanelOpen => '搜索与筛选';

  @override
  String get dashboardSearchPanelClose => '收起搜索';

  @override
  String get dashboardSearchActiveBadge => '筛选中';

  @override
  String get todaySummaryTitle => '今日';

  @override
  String get todaySummaryEmpty => '暂无「今天起 7 天内」的倒数事件。';

  @override
  String get todaySummaryCreateEvent => '新建事件';

  @override
  String get todaySummaryShowAllCategories => '全部分类';

  @override
  String get todaySummaryOnlyCurrentCategory => '与首页分类筛选一致';

  @override
  String get dashboardTodaySummaryButton => '今日';

  @override
  String get emptySearchResults => '没有找到匹配的事件';

  @override
  String get onboardingHint => '新建事件，选择分类';

  @override
  String get addCategoryTitle => '添加分类';

  @override
  String get categoryNameLabel => '名称';

  @override
  String get categoryIconLabel => '图标（emoji）';

  @override
  String get filterByCategory => '按分类查看';

  @override
  String get tooltipAddCategory => '添加分类';

  @override
  String get sectionCategoryShelf => '分类书架';

  @override
  String get sectionListFilter => '列表与筛选';

  @override
  String get sectionTools => '工具';

  @override
  String get toolDateCalculator => '日期计算器';

  @override
  String get toolMilestone => '里程碑';

  @override
  String get allEvents => '全部事件';

  @override
  String get tooltipDeleteCategory => '删除分类';

  @override
  String get newEvent => '新建事件';

  @override
  String eventCount(int count) {
    return '$count 条';
  }

  @override
  String get archiveTitle => '归档与隐藏';

  @override
  String get archivePlaceholder => '归档功能开发中，敬请期待';

  @override
  String get historySampleData => '当前为内置示例数据（网络不可用或该日无缓存时）';

  @override
  String get historyWikimedia => '史实条目来自维基媒体项目';

  @override
  String get historySupabaseAi => '含 Supabase AI 补充';

  @override
  String get historyIdaily => 'iDaily 每日环球视野';

  @override
  String get historyExploreTagline => '探索历史上的今天，发现那些改变世界的瞬间。';

  @override
  String get historyHoliday => '节日';

  @override
  String get historyEvents => '历史事件';

  @override
  String get historyEmptySupabase =>
      '暂无数据。请下拉刷新，或稍后重试（维基媒体 API 需网络可达）。已配置 Supabase 时将尝试合并 AI 补充。';

  @override
  String get historyEmpty => '暂无数据。请下拉刷新，或稍后重试（史实内容来自维基媒体 API，需网络可达）。';

  @override
  String get dashboardTodayFocus => '今日焦点';

  @override
  String dashboardDaysLeft(int days) {
    return '$days 天';
  }

  @override
  String dashboardSelectedCount(int count) {
    return '已选 $count 项';
  }

  @override
  String get dashboardCancelSelection => '取消选择';

  @override
  String get dashboardBatchMarkCompleted => '批量标记完成';

  @override
  String get dashboardBatchArchive => '批量归档';

  @override
  String get dashboardBatchUpdateCategory => '批量改分类';

  @override
  String get dashboardBatchCategoryTitle => '批量修改分类';

  @override
  String get dashboardBatchUpdateReminder => '批量改提醒';

  @override
  String get dashboardBatchReminderTitle => '批量修改提醒预设';

  @override
  String get dashboardFilterAll => '全部';

  @override
  String get dashboardFilterActive => '进行中';

  @override
  String get dashboardFilterCompleted => '已完成';

  @override
  String historyYearReviewTitle(String year) {
    return '$year 年度回顾（雏形）';
  }

  @override
  String get historySummaryTotal => '总事件';

  @override
  String get historySummaryActive => '进行中';

  @override
  String get historySummaryCompleted => '已完成';

  @override
  String get historySummaryArchived => '已归档';

  @override
  String get historyCompletionRate => '完成率';

  @override
  String get historyCategoryRatio => '分类占比';

  @override
  String get historyArchivedEvents => '已归档事件';

  @override
  String historyArchivedCount(String count) {
    return '共 $count 条';
  }

  @override
  String get historyArchivedEmpty => '暂无归档事件';

  @override
  String get historyRestore => '恢复';

  @override
  String get historyDelete => '删除';

  @override
  String get profileSectionCommon => '常用';

  @override
  String get profileSettings => '设置';

  @override
  String get profileFeedback => '意见反馈';

  @override
  String get profileAccountSecurity => '账号与安全';

  @override
  String get profileExportPng => '导出为图片分享';

  @override
  String get toastExportOk => '已生成图片，请在分享面板中保存或发送';

  @override
  String get toastExportEmpty => '暂无事件可导出';

  @override
  String get profileSectionAboutAccount => '关于与账号';

  @override
  String get profilePrivacy => '隐私政策';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileDeleteAccount => '注销账号';

  @override
  String get profileDeleteAccountConfirmTitle => '申请注销账号';

  @override
  String get profileDeleteAccountConfirmBody =>
      '确认后将拉起邮件发送到客服邮箱，我们会按隐私政策处理你的注销申请。';

  @override
  String get profileDeleteAccountEmailSubject => '吉辰万年历 账号注销申请';

  @override
  String get profileDeleteAccountEmailFallback =>
      '无法打开邮箱应用，请手动发送邮件到 ruancanghui@163.com 申请注销。';

  @override
  String get milestoneTitle => '里程碑';

  @override
  String get milestoneEmpty => '暂无事件，请先在首页创建';

  @override
  String get milestoneSubtitle => '按与今天的时间距离查看你的事件（近到远）。';

  @override
  String get milestoneSection7d => '1～7 天';

  @override
  String get milestoneSection30d => '8～30 天';

  @override
  String get milestoneSectionFar => '更远';

  @override
  String milestoneCardDesc(
    String cat,
    String dateLine,
    String dist,
    String label,
  ) {
    return '$cat · $dateLine · 距今日 $dist 天 · $label';
  }

  @override
  String get milestoneReached => '已到达里程碑！';

  @override
  String get milestoneApproaching => '即将到达里程碑';

  @override
  String get dateCalcTitle => '日期计算';

  @override
  String get dateCalcTabInterval => '日期间隔';

  @override
  String get dateCalcTabShift => '日期推算';

  @override
  String get dateCalcStartLunarPicker => '起始日用农历选择';

  @override
  String get dateCalcStart => '起始日';

  @override
  String get dateCalcEndLunarPicker => '结束日用农历选择';

  @override
  String get dateCalcEnd => '结束日';

  @override
  String get dateCalcInclusive => '包含起止日';

  @override
  String get dateCalcCompute => '计算';

  @override
  String dateCalcIntervalDays(int n) {
    return '间隔：$n 天';
  }

  @override
  String dateCalcStartLine(String date) {
    return '起始：$date';
  }

  @override
  String dateCalcLunarLine(String lunar) {
    return '农历：$lunar';
  }

  @override
  String dateCalcEndLine(String date) {
    return '结束：$date';
  }

  @override
  String get dateCalcBaseLunarPicker => '基准日用农历选择';

  @override
  String get dateCalcBase => '基准日';

  @override
  String get dateCalcDaysLabel => '天数';

  @override
  String get dateCalcDaysHint => '整数';

  @override
  String get dateCalcBefore => 'N 天前';

  @override
  String get dateCalcAfter => 'N 天后';

  @override
  String get dateCalcResult => '推算结果';

  @override
  String dateCalcGregorianLine(String date) {
    return '公历：$date';
  }

  @override
  String get loginTitleSignIn => '登录';

  @override
  String get loginTitleSignUp => '注册';

  @override
  String get loginEmail => '邮箱';

  @override
  String get loginPassword => '密码';

  @override
  String get loginCtaEnter => '登录并进入首页';

  @override
  String get loginCtaRegister => '注册并进入首页';

  @override
  String get loginSwitchToSignIn => '已有账号？去登录';

  @override
  String get loginSwitchToSignUp => '没有账号？注册';

  @override
  String get loginSupabaseMissing =>
      '未配置 Supabase（SUPABASE_URL / SUPABASE_ANON_KEY）。将使用演示登录，事件不会上云。';

  @override
  String get loginDemo => '演示登录并进入首页';

  @override
  String get eventDetailTitle => '事件';

  @override
  String get eventDetailNotFound => '未找到该事件或列表未同步';

  @override
  String get eventDetailNotifyOff => '未开启';

  @override
  String eventDetailNotifyOn(String time) {
    return '已开启 · $time';
  }

  @override
  String get eventDetailDeleteTitle => '删除事件？';

  @override
  String get eventDetailDeleteBody => '此操作不可撤销。';

  @override
  String get eventDetailTargetDate => '目标日';

  @override
  String get eventDetailLunar => '农历';

  @override
  String get eventDetailMode => '模式';

  @override
  String get eventDetailModeCountdown => '倒计时';

  @override
  String get eventDetailModeElapsed => '正计时';

  @override
  String get eventDetailReminder => '提醒';

  @override
  String get klingLoading => '加载中…';

  @override
  String get legalPrivacyTitle => '隐私政策';

  @override
  String get legalTermsTitle => '用户协议';

  @override
  String get legalPrivacyBody =>
      '完整正文见应用内文档；摘要：我们按最小必要原则处理数据，详情以本页 Markdown 全文为准。';

  @override
  String get legalTermsBody => '完整正文见应用内文档；使用本应用即表示您同意遵守用户协议全文。';

  @override
  String get legalMdLoadError => '文档加载失败，请稍后重试或重启应用。';

  @override
  String get legalConsentTitle => '欢迎使用 吉辰万年历';

  @override
  String get legalConsentMessage =>
      '为使用本应用，请阅读并同意《用户协议》与《隐私政策》。您可点击下方链接查看全文；同意后将继续进入应用。';

  @override
  String get legalConsentAgree => '同意并继续';

  @override
  String get legalConsentDisagree => '不同意并退出';

  @override
  String get legalConsentViewTerms => '查看《用户协议》';

  @override
  String get legalConsentViewPrivacy => '查看《隐私政策》';

  @override
  String get accountSecurityTitle => '账号与安全';

  @override
  String get accountLoginPrompt => '登录后可编辑昵称与查看账号信息。';

  @override
  String get accountGoLogin => '去登录';

  @override
  String get accountUserId => '用户 ID';

  @override
  String get accountEmail => '邮箱';

  @override
  String get accountLoginMethod => '登录方式';

  @override
  String get accountLoginMethodSupabase => 'Supabase 邮箱账号';

  @override
  String get accountNickname => '昵称';

  @override
  String get accountNicknameHint => '仅保存在本机用户资料中';

  @override
  String get toastNicknameEmpty => '昵称不能为空';

  @override
  String get toastNicknameTooLong => '昵称最多 32 字';

  @override
  String get toastSaved => '已保存';

  @override
  String get feedbackTitle => '意见反馈';

  @override
  String get feedbackIntro => '请选择类型并描述问题或建议。内容仅保存在本设备，便于后续版本排查与改进。';

  @override
  String get feedbackTypeLabel => '反馈类型';

  @override
  String get feedbackContentLabel => '反馈内容';

  @override
  String get feedbackContentHint => '请尽量说明操作步骤、期望与实际现象';

  @override
  String get feedbackTypeFeature => '功能建议';

  @override
  String get feedbackTypeBug => 'Bug 反馈';

  @override
  String get feedbackTypeAccount => '账号与同步';

  @override
  String get feedbackTypeOther => '其他';

  @override
  String get toastFeedbackEmpty => '请填写反馈内容';

  @override
  String toastFeedbackTooLong(int max) {
    return '内容最多 $max 字';
  }

  @override
  String get toastFeedbackSavedLocal => '已保存到本机';

  @override
  String get permNotifyMasterOffTitle => '应用内通知总开关已关闭';

  @override
  String get permNotifyMasterOffBody => '请先在「设置」中打开「通知总开关」，才能为事件安排提醒。';

  @override
  String get permGoEnable => '去开启';

  @override
  String get permNeedSystemNotifyTitle => '需要系统通知权限';

  @override
  String get permNeedSystemNotifyBodyIos => '系统已关闭通知。请到「设置 → 吉辰万年历 → 通知」中开启。';

  @override
  String get permNeedSystemNotifyBodyGeneric => '需要系统通知权限才能提醒重要日期。';

  @override
  String get permOpenSystemSettings => '打开系统设置';

  @override
  String get permNeedCalendarTitle => '需要日历访问权限';

  @override
  String get permNeedCalendarBodyIos => '系统已拒绝日历权限。请到「设置 → 吉辰万年历」中开启「日历」。';

  @override
  String get permNeedCalendarBodyGeneric => '将重要日期写入系统日历时，需要日历访问权限。';

  @override
  String get permNeedRemindersTitle => '需要提醒事项访问权限';

  @override
  String get permNeedRemindersBodyIos => '系统已拒绝提醒事项权限。请到「设置 → 吉辰万年历」中开启「提醒事项」。';

  @override
  String get permNeedRemindersBodyGeneric => '将日期同步到系统「提醒事项」时需要该权限。';

  @override
  String get permNotifyMasterOffSaveBody =>
      '需要先在应用内打开「通知总开关」，才能为事件安排本地提醒。\n\n你也可以先保存事件，稍后在「设置」中开启通知后再编辑本事件。';

  @override
  String get permSaveWithoutReminder => '仍保存，暂不提醒';

  @override
  String get permNeedNotifyDetailTitle => '需要系统通知权限';

  @override
  String get permNeedNotifyDetailBodyIos =>
      '系统已关闭通知或未再询问。请到「设置 → 吉辰万年历 → 通知」中开启，否则无法准时提醒。';

  @override
  String get permNeedNotifyDetailBodyGeneric =>
      '需要系统「通知」权限才能生成本地提醒。请在系统设置中为本应用开启通知。';

  @override
  String get toastEnterEventTitle => '请输入事件名称';

  @override
  String toastTitleMax(int max) {
    return '名称最多 $max 字';
  }

  @override
  String get toastSaveFailed => '保存失败，请检查网络或登录状态';

  @override
  String get toastSavedReminderPending =>
      '已保存。提醒未生效：可稍后在「设置」或系统通知权限中开启后，再编辑本事件。';

  @override
  String get toastAddedCalReminders => '已加入日历与提醒事项';

  @override
  String get toastAddedCalNoRemindersPerm => '已加入日历；提醒事项未写入：无提醒事项权限';

  @override
  String get toastAddedCalRemindersFail => '已加入日历；提醒事项写入失败，请稍后重试';

  @override
  String get toastAddedCal => '已加入日历';

  @override
  String get toastCalNoPerm => '未写入日历：无日历权限，请到系统设置中开启';

  @override
  String get toastCalWriteFail => '写入系统日历失败，请检查权限或稍后重试';

  @override
  String get repeatSingle => '单次';

  @override
  String get repeatYearly => '每年';

  @override
  String get repeatMonthly => '每月';

  @override
  String get repeatWeekly => '每周';

  @override
  String get repeatDaily => '每日';

  @override
  String get remindSameDay => '当天';

  @override
  String get remind1DayBefore => '提前1天';

  @override
  String get remind3DaysBefore => '提前3天';

  @override
  String get remind7DaysBefore => '提前7天';

  @override
  String remindNDaysBefore(Object n) {
    return '提前$n天';
  }

  @override
  String get eventFormReminderRules => '提醒规则';

  @override
  String get eventFormRepeat => '重复';

  @override
  String get eventFormTime => '时间';

  @override
  String get eventFormAdvance => '提前';

  @override
  String get dropdownSameDay => '当天';

  @override
  String get dropdown1DayBefore => '提前 1 天';

  @override
  String get dropdown3DaysBefore => '提前 3 天';

  @override
  String get dropdown7DaysBefore => '提前 7 天';

  @override
  String get commonDone => '完成';

  @override
  String get eventFormTitleEdit => '编辑事件';

  @override
  String get eventFormTitleCreate => '创建事件';

  @override
  String get eventFormSave => '保存';

  @override
  String get eventFormNameLabel => '事件名称';

  @override
  String get eventFormNameHint => '请输入重要日子的名称';

  @override
  String get eventFormDate => '日期';

  @override
  String get eventFormLunar => '农历';

  @override
  String get eventFormCategory => '分类';

  @override
  String get eventFormColorLabel => '颜色';

  @override
  String get eventFormColorReset => '重置';

  @override
  String get eventFormTimer => '计时';

  @override
  String get eventFormCountdown => '倒计时';

  @override
  String get eventFormElapsed => '正计时';

  @override
  String get eventFormReminder => '提醒';

  @override
  String get eventFormReminderHint => '开启时将检查应用内通知开关与系统通知权限';

  @override
  String get eventFormReminderConfigure => '点按设置重复、时间与提前';

  @override
  String get eventFormCalendarAfterSave => '保存后加入系统日历';

  @override
  String get eventFormCalendarHint => '开启时会请求日历权限；保存后直接写入系统日历（可与上方应用内提醒并存）';

  @override
  String get eventFormRemindersIos => '同时写入提醒事项';

  @override
  String get eventFormRemindersIosHint => '需单独授权提醒事项；与上方「应用内通知提醒」无关';

  @override
  String get eventFormReminderDetail => '提醒详情';

  @override
  String get eventFormReminderType => '重复';

  @override
  String get eventFormReminderSingle => '仅一次';

  @override
  String get eventFormReminderDaily => '每天';

  @override
  String get eventFormReminderWeekly => '每周';

  @override
  String get eventFormReminderMonthly => '每月';

  @override
  String get eventFormReminderYearly => '每年';

  @override
  String get eventFormHardDeadline => '硬截止';

  @override
  String get eventFormHardDeadlineHint => '在列表中更醒目；倒数且「仅一次」时可一键写入 7/3/1 天节奏提醒。';

  @override
  String get eventFormApplyRhythm731 => '应用 7 / 3 / 1 天节奏';

  @override
  String get eventFormRhythm731Applied => '已选择节奏，保存后写入提醒';

  @override
  String get eventFormRhythm731Requires => '需为倒数、重复为「仅一次」且已开启提醒';

  @override
  String get eventDetailShare => '分享';

  @override
  String get eventShareFilename => 'jichen-event.png';

  @override
  String get eventShareIcsFilename => 'jichen-event.ics';

  @override
  String get eventShareText => '吉辰万年历 · 事件';

  @override
  String get eventShareWebFallback => '网页版暂以文字分享（图片分享请用手机或桌面端）。';

  @override
  String get networkErrCancelled => '请求取消';

  @override
  String get networkErrConnectionTimeout => '连接超时';

  @override
  String get networkErrSendTimeout => '请求超时';

  @override
  String get networkErrReceiveTimeout => '响应超时';

  @override
  String get networkErr400 => '请求语法错误';

  @override
  String get networkErr401 => '没有权限';

  @override
  String get networkErr403 => '服务器拒绝执行';

  @override
  String get networkErr404 => '无法连接服务器';

  @override
  String get networkErr405 => '请求方法被禁止';

  @override
  String get networkErr500 => '服务器内部错误';

  @override
  String get networkErr502 => '无效的请求';

  @override
  String get networkErr503 => '服务器挂了';

  @override
  String get networkErr505 => '不支持HTTP协议请求';

  @override
  String get networkErrUnknown => '未知错误';

  @override
  String get lunarPickerTitle => '选择农历（约 1901–2049）';

  @override
  String get lunarLabelYear => '年';

  @override
  String get lunarLabelMonth => '月';

  @override
  String get lunarLabelDay => '日';

  @override
  String lunarInvalidDay(String error) {
    return '无效农历日：$error';
  }

  @override
  String get notifChannelName => '事件提醒';

  @override
  String get notifChannelDescription => '吉辰万年历';

  @override
  String notifBodyLine(String app, String title, String mode, String label) {
    return '【$app】$title（$mode）：$label';
  }

  @override
  String calExportNotesLine(String app, String mode, String cat) {
    return '$app · $mode · $cat';
  }

  @override
  String get exportErrLayoutIncomplete => '无法生成图片（布局未完成），请重试';

  @override
  String get exportErrEncodeFail => '图片编码失败';

  @override
  String get exportShareFilename => 'jichen-events.png';

  @override
  String get exportShareText => '吉辰万年历 · 事件导出';

  @override
  String exportFailWithError(String error) {
    return '导出失败：$error';
  }

  @override
  String get exportListSubtitle => '事件清单 · 图片导出';

  @override
  String get exportTimeLabel => '导出时间';

  @override
  String exportMetaTotalSorted(int count) {
    return '共 $count 条事件 · 已按与「今天」的距离从近到远排序';
  }

  @override
  String exportSolarLine(String line) {
    return '公历：$line';
  }

  @override
  String exportLunarLine(String line) {
    return '农历：$line';
  }

  @override
  String exportTypeCategoryLine(String type, String cat) {
    return '类型：$type  ·  分类：$cat';
  }

  @override
  String get exportTypeCountdownShort => '倒数日';

  @override
  String get exportTypeCountupShort => '正数日';

  @override
  String exportTruncatedNote(int total, int limit) {
    return '共 $total 条事件，图中仅展示前 $limit 条';
  }

  @override
  String get exportFooterTagline => '吉辰万年历 · 记录每一个重要日子';

  @override
  String get exportSummaryCdToday => '倒数日 · 就是今天';

  @override
  String get exportSummaryCdPast => '倒数日 · 目标日期已过';

  @override
  String exportSummaryCdRemain(int n) {
    return '倒数日 · 还剩 $n 天';
  }

  @override
  String get exportSummaryCuFirst => '正数日 · 起始日（第 1 天）';

  @override
  String exportSummaryCuNth(int n) {
    return '正数日 · 第 $n 天';
  }

  @override
  String get exportHeroToday => '今天';

  @override
  String get exportHeroFirstDay => '第 1 天';

  @override
  String get exportHeroUnitDay => '天';

  @override
  String get exportCountupPrefix => '第';

  @override
  String get exportCountupSuffix => '天';

  @override
  String get categoryMemorial => '纪念日';

  @override
  String get categoryWork => '工作';

  @override
  String get categoryLife => '生活';

  @override
  String get builtinEventNextSaturday => '距离星期六';

  @override
  String get builtinEventYearEnd => '距离今年结束';

  @override
  String get builtinEventAppleFounded => 'Apple 成立日';

  @override
  String get dayLabelToday => '今天';

  @override
  String get dayLabelCountupFirst => '第1天';

  @override
  String get repoErrNotLoggedInList => '未登录或会话已失效，请重新登录';

  @override
  String get repoErrNotLoggedInWrite => '未登录或会话已失效，无法写入云端';

  @override
  String get repoErrNotLoggedIn => '未登录或会话已失效';

  @override
  String get repoErrLocalDupId => '本地数据异常：ID 重复';

  @override
  String get repoErrLocalNotFound => '本地未找到该事件';

  @override
  String get repoErrDbSchema =>
      '数据库缺少字段（如 reminder_json），请执行 supabase/migrations 后重试';
}
