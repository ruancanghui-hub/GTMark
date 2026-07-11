#!/usr/bin/env python3
"""One-off generator for app_en.arb / app_zh.arb — edit tuples below then run: python3 scripts/gen_l10n_arb.py"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
L10N = ROOT / "lib" / "l10n"

# (key, en, zh)
PAIRS: list[tuple[str, str, str]] = [
    ("appTitle", "吉辰万年历", "吉辰万年历"),
    ("appNameShort", "吉辰万年历", "吉辰万年历"),
    ("commonCancel", "Cancel", "取消"),
    ("commonDelete", "Delete", "删除"),
    ("commonAdd", "Add", "添加"),
    ("commonSave", "Save", "保存"),
    ("commonSubmit", "Submit", "提交"),
    ("commonClose", "Close", "关闭"),
    ("commonOk", "OK", "确定"),
    ("notFoundTitle", "Page not found", "页面不存在"),
    ("notFoundBackHome", "Back to home", "回到首页"),
    ("splashTagline", "Calendar · lucky days · reminders · blessings", "查日期 · 择吉 · 提醒 · 发祝福"),
    ("splashMessage", "See solar and lunar dates, pick auspicious days, and never miss what matters.", "查日期 · 择吉 · 提醒 · 发祝福，重要日子不再错过。"),
    ("splashLoading", "Loading…", "加载中…"),
    ("splashVideoUnavailable", "Video unavailable", "视频暂不可用"),
    ("settingsTitle", "Settings", "设置"),
    ("settingsSectionDateDisplay", "Date & display", "日期与显示"),
    ("settingsHomeCardOrderTitle", "Primary / secondary line on home cards", "首页卡片主副标题顺序"),
    ("settingsHomeCardOrderSubtitle", "Which line shows first: Gregorian or lunar", "控制公历、农历两行谁先展示"),
    ("settingsSolarFirst", "Gregorian first", "公历优先"),
    ("settingsLunarFirst", "Lunar first", "农历优先"),
    ("settingsSectionNotify", "Notifications", "通知"),
    ("settingsNotifyMasterTitle", "Notifications master switch", "通知总开关"),
    ("settingsNotifyMasterSubtitle", "When off, no new reminders are scheduled (saved reminder settings remain).", "关闭后不再调度新提醒（已保存的提醒配置仍保留）"),
    ("settingsSectionLegal", "Legal & help", "法律与帮助"),
    ("settingsPrivacy", "Privacy policy", "隐私政策"),
    ("settingsTerms", "Terms of service", "用户协议"),
    ("settingsFeedback", "Feedback", "意见反馈"),
    ("settingsSectionAbout", "About", "关于"),
    ("settingsAboutApp", "About LuckyDate", "关于 吉辰万年历"),
    ("settingsVersion", "Version {version}", "版本 {version}"),
    ("settingsAboutBlurb", "Important date reminders and local notifications. When you sign in with email, events sync to your configured cloud.", "重要日期管理与本地提醒。使用邮箱登录时，事件数据同步至您配置的云端服务。"),
    ("settingsSectionLanguage", "Language", "语言"),
    ("settingsLanguageEnglish", "English", "English"),
    ("settingsLanguageChinese", "简体中文", "简体中文"),
    ("copyrightLegalese", "© 2026", "© 2026"),
    ("navCountdownDay", "Countdown", "倒数日"),
    ("navCountdownBook", "Countdown book", "倒数本"),
    ("navHistoryToday", "Today in history", "历史上的今天"),
    ("navProfile", "Profile", "我的"),
    ("sidePanelGuest", "Local user", "本地用户"),
    ("sidePanelOpenSettings", "Open settings", "打开设置"),
    ("appBarTitleDays", "LuckyDate · Countdown", "吉辰万年历 · 倒数日"),
    ("appBarTitleBook", "Countdown book", "倒数本"),
    ("appBarTitleHistory", "Today in history", "历史上的今天"),
    ("appBarTitleProfile", "Profile", "我的"),
    ("appBarTitleDefault", "LuckyDate", "吉辰万年历"),
    ("appBarFiltered", "LuckyDate · {label} only", "吉辰万年历 · 仅 {label}"),
    ("deleteEventTitle", "Delete event?", "删除事件？"),
    ("deleteEventBody", "「{title}」will be permanently deleted.", "「{title}」将被永久删除。"),
    ("deleteCategoryTitle", "Delete category?", "删除分类？"),
    ("deleteCategoryBody", "Remove \"{name}\". You can only delete when it has no events.", "将删除「{name}」。仅当该分类下无事件时可删除。"),
    ("emptyEventsFiltered", "No events in this category. Tap + or change filter.", "该分类下暂无事件，点击右上角 + 添加或切换筛选"),
    ("emptyEvents", "No events yet. Tap + to add.", "暂无事件，点击右上角 + 添加"),
    ("onboardingHint", "Create an event and pick a category", "新建事件，选择分类"),
    ("addCategoryTitle", "Add category", "添加分类"),
    ("categoryNameLabel", "Name", "名称"),
    ("categoryIconLabel", "Icon (emoji)", "图标（emoji）"),
    ("filterByCategory", "Browse by category", "按分类查看"),
    ("tooltipAddCategory", "Add category", "添加分类"),
    ("sectionCategoryShelf", "Category shelf", "分类书架"),
    ("sectionListFilter", "List & filter", "列表与筛选"),
    ("sectionTools", "Tools", "工具"),
    ("toolDateCalculator", "Date calculator", "日期计算器"),
    ("toolMilestone", "Milestones", "里程碑"),
    ("allEvents", "All events", "全部事件"),
    ("tooltipDeleteCategory", "Delete category", "删除分类"),
    ("newEvent", "New event", "新建事件"),
    ("eventCount", "{count} items", "{count} 条"),
    ("archiveTitle", "Archive & hide", "归档与隐藏"),
    ("archivePlaceholder", "Archive is coming soon.", "归档功能开发中，敬请期待"),
    ("historySampleData", "Showing sample data (offline or no cache for this day).", "当前为内置示例数据（网络不可用或该日无缓存时）"),
    ("historyWikimedia", "Entries from Wikimedia projects.", "史实条目来自维基媒体项目"),
    ("historySupabaseAi", "Includes Supabase AI supplement.", "含 Supabase AI 补充"),
    ("historyIdaily", "iDaily global view", "iDaily 每日环球视野"),
    ("historyExploreTagline", "Explore today in history.", "探索历史上的今天，发现那些改变世界的瞬间。"),
    ("historyHoliday", "Holidays", "节日"),
    ("historyEvents", "Historical events", "历史事件"),
    ("historyEmptySupabase", "No data. Pull to refresh or try again (Wikimedia API needs network). With Supabase, AI merge is attempted.", "暂无数据。请下拉刷新，或稍后重试（维基媒体 API 需网络可达）。已配置 Supabase 时将尝试合并 AI 补充。"),
    ("historyEmpty", "No data. Pull to refresh (Wikimedia API needs network).", "暂无数据。请下拉刷新，或稍后重试（史实内容来自维基媒体 API，需网络可达）。"),
    ("profileSectionCommon", "Common", "常用"),
    ("profileSettings", "Settings", "设置"),
    ("profileFeedback", "Feedback", "意见反馈"),
    ("profileAccountSecurity", "Account & security", "账号与安全"),
    ("profileExportPng", "Export as image", "导出为图片分享"),
    ("toastExportOk", "Image generated. Save or share from the share sheet.", "已生成图片，请在分享面板中保存或发送"),
    ("toastExportEmpty", "No events to export", "暂无事件可导出"),
    ("profileSectionAboutAccount", "About & account", "关于与账号"),
    ("profilePrivacy", "Privacy policy", "隐私政策"),
    ("profileLogout", "Log out", "退出登录"),
    ("milestoneTitle", "Milestones", "里程碑"),
    ("milestoneEmpty", "No events yet. Create one on the home tab.", "暂无事件，请先在首页创建"),
    ("milestoneSubtitle", "Your events by distance from today (nearest first).", "按与今天的时间距离查看你的事件（近到远）。"),
    ("milestoneSection7d", "Within 7 days", "7 天内"),
    ("milestoneSection30d", "8–30 days", "8～30 天"),
    ("milestoneSectionFar", "Farther", "更远"),
    ("milestoneCardDesc", "{cat} · {dateLine} · {dist} days from today · {label}", "{cat} · {dateLine} · 距今日 {dist} 天 · {label}"),
    ("dateCalcTitle", "Date calculator", "日期计算"),
    ("dateCalcTabInterval", "Interval", "日期间隔"),
    ("dateCalcTabShift", "Shift date", "日期推算"),
    ("dateCalcStartLunarPicker", "Start date (lunar picker)", "起始日用农历选择"),
    ("dateCalcStart", "Start date", "起始日"),
    ("dateCalcEndLunarPicker", "End date (lunar picker)", "结束日用农历选择"),
    ("dateCalcEnd", "End date", "结束日"),
    ("dateCalcInclusive", "Include start & end", "包含起止日"),
    ("dateCalcCompute", "Calculate", "计算"),
    ("dateCalcIntervalDays", "Interval: {n} days", "间隔：{n} 天"),
    ("dateCalcStartLine", "Start: {date}", "起始：{date}"),
    ("dateCalcLunarLine", "Lunar: {lunar}", "农历：{lunar}"),
    ("dateCalcEndLine", "End: {date}", "结束：{date}"),
    ("dateCalcBaseLunarPicker", "Base date (lunar picker)", "基准日用农历选择"),
    ("dateCalcBase", "Base date", "基准日"),
    ("dateCalcDaysLabel", "Days", "天数"),
    ("dateCalcDaysHint", "Integer", "整数"),
    ("dateCalcBefore", "N days before", "N 天前"),
    ("dateCalcAfter", "N days after", "N 天后"),
    ("dateCalcResult", "Result", "推算结果"),
    ("dateCalcGregorianLine", "Gregorian: {date}", "公历：{date}"),
    ("loginTitleSignIn", "Sign in", "登录"),
    ("loginTitleSignUp", "Sign up", "注册"),
    ("loginEmail", "Email", "邮箱"),
    ("loginPassword", "Password", "密码"),
    ("loginCtaEnter", "Sign in & go to home", "登录并进入首页"),
    ("loginCtaRegister", "Register & go to home", "注册并进入首页"),
    ("loginSwitchToSignIn", "Have an account? Sign in", "已有账号？去登录"),
    ("loginSwitchToSignUp", "No account? Register", "没有账号？注册"),
    ("loginSupabaseMissing", "Supabase not configured (SUPABASE_URL / SUPABASE_ANON_KEY). Demo sign-in; events won't sync to cloud.", "未配置 Supabase（SUPABASE_URL / SUPABASE_ANON_KEY）。将使用演示登录，事件不会上云。"),
    ("loginDemo", "Demo sign-in & go to home", "演示登录并进入首页"),
    ("eventDetailTitle", "Event", "事件"),
    ("eventDetailNotFound", "Event not found or list out of sync.", "未找到该事件或列表未同步"),
    ("eventDetailNotifyOff", "Off", "未开启"),
    ("eventDetailNotifyOn", "On · {time}", "已开启 · {time}"),
    ("eventDetailDeleteTitle", "Delete event?", "删除事件？"),
    ("eventDetailDeleteBody", "This cannot be undone.", "此操作不可撤销。"),
    ("eventDetailTargetDate", "Target date", "目标日"),
    ("eventDetailLunar", "Lunar", "农历"),
    ("eventDetailMode", "Mode", "模式"),
    ("eventDetailModeCountdown", "Countdown", "倒计时"),
    ("eventDetailModeElapsed", "Elapsed", "正计时"),
    ("eventDetailReminder", "Reminder", "提醒"),
    ("klingLoading", "Loading…", "加载中…"),
    ("legalPrivacyTitle", "Privacy policy", "隐私政策"),
    ("legalTermsTitle", "Terms of service", "用户协议"),
    ("legalPrivacyBody", "「吉辰万年历」 respects your privacy.\n\n1. Local data: preferences (e.g. date order, notifications) and events you create without signing in are stored on device.\n\n2. Cloud data: if you sign in with email, events and account data are stored per your provider's security policy. Do not put highly sensitive data in events.\n\n3. Notifications: only used when you enable reminders and grant OS permission.\n\n4. We don't sell your data. Uninstall clears local data; follow your provider for cloud deletion.\n\nReplace with full legal text before release.", "「吉辰万年历」尊重您的隐私。\n\n1. 本地数据：应用会在本机存储您的偏好设置（如日期显示顺序、通知总开关）及部分未登录状态下创建的事件数据。\n\n2. 云端数据：若您使用邮箱登录并连接服务端，事件与账号相关信息将按服务提供商的安全策略存储与传输。请勿在事件中填写高度敏感信息。\n\n3. 通知：仅在您开启提醒且授予系统通知权限后，用于在约定时间提示您关注的事件。\n\n4. 我们不会将您的数据出售给第三方。若您注销或卸载应用，本地数据将随卸载清除；云端数据请遵循服务端提供的删除指引。\n\n本说明为概要模板，正式上架前请由法务审阅并替换为完整隐私政策。"),
    ("legalTermsBody", "Welcome to 「吉辰万年历」.\n\n1. Use the app lawfully.\n\n2. Provided as-is; we are not liable for data loss from network, device, or third parties. Back up important data.\n\n3. Features may change without notice.\n\nReplace with full terms before release.", "欢迎使用「吉辰万年历」。\n\n1. 您应合法使用本应用，不得利用其从事违法或侵害他人权益的行为。\n\n2. 本应用按「现状」提供，开发者不对因网络、设备或第三方服务导致的数据丢失承担责任，建议您定期备份重要信息。\n\n3. 功能可能随版本更新调整，恕不另行通知。\n\n正式上架前请将本协议替换为经审阅的完整版本。"),
    ("accountSecurityTitle", "Account & security", "账号与安全"),
    ("accountLoginPrompt", "Sign in to edit nickname and view account info.", "登录后可编辑昵称与查看账号信息。"),
    ("accountGoLogin", "Sign in", "去登录"),
    ("accountUserId", "User ID", "用户 ID"),
    ("accountEmail", "Email", "邮箱"),
    ("accountLoginMethod", "Sign-in method", "登录方式"),
    ("accountLoginMethodSupabase", "Supabase email", "Supabase 邮箱账号"),
    ("accountNickname", "Nickname", "昵称"),
    ("accountNicknameHint", "Stored only in local profile", "仅保存在本机用户资料中"),
    ("toastNicknameEmpty", "Nickname cannot be empty", "昵称不能为空"),
    ("toastNicknameTooLong", "Nickname max 32 characters", "昵称最多 32 字"),
    ("toastSaved", "Saved", "已保存"),
    ("feedbackTitle", "Feedback", "意见反馈"),
    ("feedbackIntro", "Choose a type and describe the issue. Content is saved on this device only.", "请选择类型并描述问题或建议。内容仅保存在本设备，便于后续版本排查与改进。"),
    ("feedbackTypeLabel", "Type", "反馈类型"),
    ("feedbackContentLabel", "Details", "反馈内容"),
    ("feedbackContentHint", "Steps, expected vs actual behavior", "请尽量说明操作步骤、期望与实际现象"),
    ("feedbackTypeFeature", "Feature request", "功能建议"),
    ("feedbackTypeBug", "Bug report", "Bug 反馈"),
    ("feedbackTypeAccount", "Account & sync", "账号与同步"),
    ("feedbackTypeOther", "Other", "其他"),
    ("toastFeedbackEmpty", "Please enter feedback", "请填写反馈内容"),
    ("toastFeedbackTooLong", "Content exceeds {max} characters", "内容最多 {max} 字"),
    ("toastFeedbackSavedLocal", "Saved on device", "已保存到本机"),
]

# Event form & toasts (large set)
EVENT_FORM_EXTRA: list[tuple[str, str, str]] = [
    ("permNotifyMasterOffTitle", "In-app notifications are off", "应用内通知总开关已关闭"),
    ("permNotifyMasterOffBody", "Turn on \"Notifications master switch\" in Settings first.", "请先在「设置」中打开「通知总开关」，才能为事件安排提醒。"),
    ("permGoEnable", "Open Settings", "去开启"),
    ("permNeedSystemNotifyTitle", "Notification permission needed", "需要系统通知权限"),
    ("permNeedSystemNotifyBodyIos", "Notifications are off. Enable in Settings → LuckyDate → Notifications.", "系统已关闭通知。请到「设置 → 吉辰万年历 → 通知」中开启。"),
    ("permNeedSystemNotifyBodyGeneric", "Notification permission is required for reminders.", "需要系统通知权限才能提醒重要日期。"),
    ("permOpenSystemSettings", "Open system settings", "打开系统设置"),
    ("permNeedCalendarTitle", "Calendar access needed", "需要日历访问权限"),
    ("permNeedCalendarBodyIos", "Calendar access denied. Enable in Settings → LuckyDate.", "系统已拒绝日历权限。请到「设置 → 吉辰万年历」中开启「日历」。"),
    ("permNeedCalendarBodyGeneric", "Calendar access is needed to write events.", "将重要日期写入系统日历时，需要日历访问权限。"),
    ("permNeedRemindersTitle", "Reminders access needed", "需要提醒事项访问权限"),
    ("permNeedRemindersBodyIos", "Reminders denied. Enable in Settings → LuckyDate.", "系统已拒绝提醒事项权限。请到「设置 → 吉辰万年历」中开启「提醒事项」。"),
    ("permNeedRemindersBodyGeneric", "Reminders access is needed to sync.", "将日期同步到系统「提醒事项」时需要该权限。"),
    ("permNotifyMasterOffSaveBody", "Turn on the in-app notification switch to schedule local reminders.\n\nYou can save the event and enable notifications later in Settings.", "需要先在应用内打开「通知总开关」，才能为事件安排本地提醒。\n\n你也可以先保存事件，稍后在「设置」中开启通知后再编辑本事件。"),
    ("permSaveWithoutReminder", "Save without reminder", "仍保存，暂不提醒"),
    ("permNeedNotifyDetailTitle", "Notification permission needed", "需要系统通知权限"),
    ("permNeedNotifyDetailBodyIos", "Notifications disabled. Enable in Settings → LuckyDate → Notifications.", "系统已关闭通知或未再询问。请到「设置 → 吉辰万年历 → 通知」中开启，否则无法准时提醒。"),
    ("permNeedNotifyDetailBodyGeneric", "Grant notification permission in system settings for local reminders.", "需要系统「通知」权限才能生成本地提醒。请在系统设置中为本应用开启通知。"),
    ("toastEnterEventTitle", "Please enter event title", "请输入事件名称"),
    ("toastTitleMax", "Title max {max} characters", "名称最多 {max} 字"),
    ("toastSaveFailed", "Save failed. Check network or sign-in.", "保存失败，请检查网络或登录状态"),
    ("toastSavedReminderPending", "Saved. Reminder inactive — enable in Settings or OS permissions, then edit this event.", "已保存。提醒未生效：可稍后在「设置」或系统通知权限中开启后，再编辑本事件。"),
    ("toastAddedCalReminders", "Added to Calendar & Reminders", "已加入日历与提醒事项"),
    ("toastAddedCalNoRemindersPerm", "Added to Calendar; Reminders skipped (no permission)", "已加入日历；提醒事项未写入：无提醒事项权限"),
    ("toastAddedCalRemindersFail", "Added to Calendar; Reminders failed, try again", "已加入日历；提醒事项写入失败，请稍后重试"),
    ("toastAddedCal", "Added to Calendar", "已加入日历"),
    ("toastCalNoPerm", "Not written to Calendar — no permission. Enable in Settings.", "未写入日历：无日历权限，请到系统设置中开启"),
    ("toastCalWriteFail", "Failed to write Calendar. Check permission or try again.", "写入系统日历失败，请检查权限或稍后重试"),
    ("repeatSingle", "Once", "单次"),
    ("repeatYearly", "Yearly", "每年"),
    ("repeatMonthly", "Monthly", "每月"),
    ("repeatWeekly", "Weekly", "每周"),
    ("repeatDaily", "Daily", "每日"),
    ("remindSameDay", "Same day", "当天"),
    ("remind1DayBefore", "1 day before", "提前1天"),
    ("remind3DaysBefore", "3 days before", "提前3天"),
    ("remind7DaysBefore", "7 days before", "提前7天"),
    ("remindNDaysBefore", "{n} days before", "提前{n}天"),
    ("eventFormReminderRules", "Reminder rules", "提醒规则"),
    ("eventFormRepeat", "Repeat", "重复"),
    ("eventFormTime", "Time", "时间"),
    ("eventFormAdvance", "Advance notice", "提前"),
    ("dropdownSameDay", "Same day", "当天"),
    ("dropdown1DayBefore", "1 day before", "提前 1 天"),
    ("dropdown3DaysBefore", "3 days before", "提前 3 天"),
    ("dropdown7DaysBefore", "7 days before", "提前 7 天"),
]

EVENT_FORM_UI: list[tuple[str, str, str]] = [
    ("commonDone", "Done", "完成"),
    ("eventFormTitleEdit", "Edit event", "编辑事件"),
    ("eventFormTitleCreate", "Create event", "创建事件"),
    ("eventFormSave", "Save", "保存"),
    ("eventFormNameLabel", "Event name", "事件名称"),
    ("eventFormNameHint", "Name this important day", "请输入重要日子的名称"),
    ("eventFormDate", "Date", "日期"),
    ("eventFormLunar", "Lunar", "农历"),
    ("eventFormCategory", "Category", "分类"),
    ("eventFormTimer", "Mode", "计时"),
    ("eventFormCountdown", "Countdown", "倒计时"),
    ("eventFormElapsed", "Elapsed", "正计时"),
    ("eventFormReminder", "Reminder", "提醒"),
    ("eventFormReminderHint", "Checks in-app notification switch and OS permission when enabled.", "开启时将检查应用内通知开关与系统通知权限"),
    ("eventFormReminderConfigure", "Tap to set repeat, time, and advance notice.", "点按设置重复、时间与提前"),
    ("eventFormCalendarAfterSave", "Add to system calendar after save", "保存后加入系统日历"),
    ("eventFormCalendarHint", "Requests calendar permission; writes to Calendar on save (can work with in-app reminders).", "开启时会请求日历权限；保存后直接写入系统日历（可与上方应用内提醒并存）"),
    ("eventFormRemindersIos", "Also write to Reminders", "同时写入提醒事项"),
    ("eventFormRemindersIosHint", "Requires Reminders permission; separate from in-app notifications.", "需单独授权提醒事项；与上方「应用内通知提醒」无关"),
]

# HTTP / Dio fallback messages (resolved via AppLocaleHolder + lookupAppLocalizations)
NETWORK_HTTP: list[tuple[str, str, str]] = [
    ("networkErrCancelled", "Request cancelled", "请求取消"),
    ("networkErrConnectionTimeout", "Connection timed out", "连接超时"),
    ("networkErrSendTimeout", "Send timed out", "请求超时"),
    ("networkErrReceiveTimeout", "Response timed out", "响应超时"),
    ("networkErr400", "Bad request", "请求语法错误"),
    ("networkErr401", "Unauthorized", "没有权限"),
    ("networkErr403", "Forbidden", "服务器拒绝执行"),
    ("networkErr404", "Cannot reach server", "无法连接服务器"),
    ("networkErr405", "Method not allowed", "请求方法被禁止"),
    ("networkErr500", "Internal server error", "服务器内部错误"),
    ("networkErr502", "Bad gateway", "无效的请求"),
    ("networkErr503", "Service unavailable", "服务器挂了"),
    ("networkErr505", "HTTP version not supported", "不支持HTTP协议请求"),
    ("networkErrUnknown", "Unknown error", "未知错误"),
]

LUNAR_PICKER: list[tuple[str, str, str]] = [
    ("lunarPickerTitle", "Pick lunar date (approx. 1901–2049)", "选择农历（约 1901–2049）"),
    ("lunarLabelYear", "Year", "年"),
    ("lunarLabelMonth", "Month", "月"),
    ("lunarLabelDay", "Day", "日"),
    ("lunarInvalidDay", "Invalid lunar date: {error}", "无效农历日：{error}"),
]

NOTIF_CAL: list[tuple[str, str, str]] = [
    ("notifChannelName", "Event reminders", "事件提醒"),
    ("notifChannelDescription", "LuckyDate", "吉辰万年历"),
    (
        "notifBodyLine",
        "[{app}] {title} ({mode}): {label}",
        "【{app}】{title}（{mode}）：{label}",
    ),
    ("calExportNotesLine", "{app} · {mode} · {cat}", "{app} · {mode} · {cat}"),
]

DATA_UI: list[tuple[str, str, str]] = [
    ("categoryMemorial", "Anniversary", "纪念日"),
    ("categoryWork", "Work", "工作"),
    ("categoryLife", "Life", "生活"),
    ("builtinEventNextSaturday", "Until Saturday", "距离星期六"),
    ("builtinEventYearEnd", "Until year end", "距离今年结束"),
    ("builtinEventAppleFounded", "Apple founded", "Apple 成立日"),
    ("dayLabelToday", "Today", "今天"),
    ("dayLabelCountupFirst", "Day 1", "第1天"),
    (
        "repoErrNotLoggedInList",
        "Not signed in or session expired. Please sign in again.",
        "未登录或会话已失效，请重新登录",
    ),
    (
        "repoErrNotLoggedInWrite",
        "Not signed in or session expired. Cannot sync to cloud.",
        "未登录或会话已失效，无法写入云端",
    ),
    (
        "repoErrNotLoggedIn",
        "Not signed in or session expired.",
        "未登录或会话已失效",
    ),
    ("repoErrLocalDupId", "Local data error: duplicate ID.", "本地数据异常：ID 重复"),
    ("repoErrLocalNotFound", "Event not found locally.", "本地未找到该事件"),
    (
        "repoErrDbSchema",
        "Database schema mismatch (e.g. missing reminder_json). Run migrations and retry.",
        "数据库缺少字段（如 reminder_json），请执行 supabase/migrations 后重试",
    ),
]

EXPORT_UI: list[tuple[str, str, str]] = [
    ("exportErrLayoutIncomplete", "Could not render image (layout not ready). Try again.", "无法生成图片（布局未完成），请重试"),
    ("exportErrEncodeFail", "Image encoding failed", "图片编码失败"),
    ("exportShareFilename", "jichen-events.png", "jichen-events.png"),
    ("exportShareText", "LuckyDate · event list export", "吉辰万年历 · 事件导出"),
    ("exportFailWithError", "Export failed: {error}", "导出失败：{error}"),
    ("exportListSubtitle", "Event list · image export", "事件清单 · 图片导出"),
    ("exportTimeLabel", "Exported at", "导出时间"),
    (
        "exportMetaTotalSorted",
        "{count} events · sorted nearest to today first",
        "共 {count} 条事件 · 已按与「今天」的距离从近到远排序",
    ),
    ("exportSolarLine", "Gregorian: {line}", "公历：{line}"),
    ("exportLunarLine", "Lunar: {line}", "农历：{line}"),
    (
        "exportTypeCategoryLine",
        "Type: {type} · Category: {cat}",
        "类型：{type}  ·  分类：{cat}",
    ),
    ("exportTypeCountdownShort", "Countdown", "倒数日"),
    ("exportTypeCountupShort", "Elapsed", "正数日"),
    (
        "exportTruncatedNote",
        "{total} events total · only the first {limit} are shown",
        "共 {total} 条事件，图中仅展示前 {limit} 条",
    ),
    (
        "exportFooterTagline",
        "LuckyDate · calendar for every important day",
        "吉辰万年历 · 记录每一个重要日子",
    ),
    ("exportSummaryCdToday", "Countdown · Today", "倒数日 · 就是今天"),
    ("exportSummaryCdPast", "Countdown · target date passed", "倒数日 · 目标日期已过"),
    ("exportSummaryCdRemain", "Countdown · {n} days left", "倒数日 · 还剩 {n} 天"),
    ("exportSummaryCuFirst", "Elapsed · start day (day 1)", "正数日 · 起始日（第 1 天）"),
    ("exportSummaryCuNth", "Elapsed · day {n}", "正数日 · 第 {n} 天"),
    ("exportHeroToday", "Today", "今天"),
    ("exportHeroFirstDay", "Day 1", "第 1 天"),
    ("exportHeroUnitDay", "days", "天"),
    ("exportCountupPrefix", "Day ", "第"),
    ("exportCountupSuffix", "", "天"),
]

PAIRS.extend(EVENT_FORM_EXTRA)
PAIRS.extend(EVENT_FORM_UI)
PAIRS.extend(NETWORK_HTTP)
PAIRS.extend(LUNAR_PICKER)
PAIRS.extend(NOTIF_CAL)
PAIRS.extend(EXPORT_UI)
PAIRS.extend(DATA_UI)


def main() -> None:
    L10N.mkdir(parents=True, exist_ok=True)
    en_obj: dict[str, str] = {"@@locale": "en"}
    zh_obj: dict[str, str] = {"@@locale": "zh"}
    for key, en, zh in PAIRS:
        en_obj[key] = en
        zh_obj[key] = zh
    # Placeholder metadata for ICU
    meta_keys = {
        "deleteEventBody": {"placeholders": {"title": {"type": "String"}}},
        "deleteCategoryBody": {"placeholders": {"name": {"type": "String"}}},
        "appBarFiltered": {"placeholders": {"label": {"type": "String"}}},
        "settingsVersion": {"placeholders": {"version": {"type": "String"}}},
        "eventCount": {"placeholders": {"count": {"type": "int"}}},
        "milestoneCardDesc": {"placeholders": {"cat": {"type": "String"}, "dateLine": {"type": "String"}, "dist": {"type": "String"}, "label": {"type": "String"}}},
        "dateCalcIntervalDays": {"placeholders": {"n": {"type": "int"}}},
        "dateCalcStartLine": {"placeholders": {"date": {"type": "String"}}},
        "dateCalcLunarLine": {"placeholders": {"lunar": {"type": "String"}}},
        "dateCalcEndLine": {"placeholders": {"date": {"type": "String"}}},
        "dateCalcGregorianLine": {"placeholders": {"date": {"type": "String"}}},
        "eventDetailNotifyOn": {"placeholders": {"time": {"type": "String"}}},
        "toastTitleMax": {"placeholders": {"max": {"type": "int"}}},
        "toastFeedbackTooLong": {"placeholders": {"max": {"type": "int"}}},
        "lunarInvalidDay": {"placeholders": {"error": {"type": "String"}}},
        "notifBodyLine": {
            "placeholders": {
                "app": {"type": "String"},
                "title": {"type": "String"},
                "mode": {"type": "String"},
                "label": {"type": "String"},
            }
        },
        "calExportNotesLine": {
            "placeholders": {
                "app": {"type": "String"},
                "mode": {"type": "String"},
                "cat": {"type": "String"},
            }
        },
        "exportFailWithError": {"placeholders": {"error": {"type": "String"}}},
        "exportMetaTotalSorted": {"placeholders": {"count": {"type": "int"}}},
        "exportSolarLine": {"placeholders": {"line": {"type": "String"}}},
        "exportLunarLine": {"placeholders": {"line": {"type": "String"}}},
        "exportTypeCategoryLine": {
            "placeholders": {"type": {"type": "String"}, "cat": {"type": "String"}}
        },
        "exportTruncatedNote": {
            "placeholders": {"total": {"type": "int"}, "limit": {"type": "int"}}
        },
        "exportSummaryCdRemain": {"placeholders": {"n": {"type": "int"}}},
        "exportSummaryCuNth": {"placeholders": {"n": {"type": "int"}}},
    }
    for k, meta in meta_keys.items():
        en_obj[f"@{k}"] = meta
        zh_obj[f"@{k}"] = meta

    def dump(obj: dict, path: Path) -> None:
        with path.open("w", encoding="utf-8") as f:
            json.dump(obj, f, ensure_ascii=False, indent=2)
            f.write("\n")

    dump(en_obj, L10N / "app_en.arb")
    dump(zh_obj, L10N / "app_zh.arb")
    print("Wrote", L10N / "app_en.arb", "and app_zh.arb", "keys:", len(PAIRS))


if __name__ == "__main__":
    main()
