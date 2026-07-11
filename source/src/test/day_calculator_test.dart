import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/day_calculator.dart';
import 'package:lianji/l10n/gen/app_localizations.dart';

// Mock AppLocalizations — complete implementation of the AppLocalizations interface.
// All members return safe English stub values; parameterized methods return
// minimally formatted output sufficient for test assertions.
class MockAppLocalizations implements AppLocalizations {
  const MockAppLocalizations();

  // --- App & common ---
  @override String get appTitle => '吉辰万年历';
  @override String get appNameShort => '吉辰万年历';
  @override String get commonCancel => 'Cancel';
  @override String get commonDelete => 'Delete';
  @override String get commonAdd => 'Add';
  @override String get commonSave => 'Save';
  @override String get commonSubmit => 'Submit';
  @override String get commonClose => 'Close';
  @override String get commonOk => 'OK';
  @override String get commonDone => 'Done';

  // --- Not found ---
  @override String get notFoundTitle => 'Page not found';
  @override String get notFoundBackHome => 'Back to home';

  // --- Splash ---
  @override String get splashTagline => '查日期 · 择吉 · 提醒 · 发祝福';
  @override String get splashMessage => '查日期 · 择吉 · 提醒 · 发祝福，重要日子不再错过。';
  @override String get splashLoading => 'Loading…';
  @override String get splashVideoUnavailable => 'Video unavailable';

  // --- Settings ---
  @override String get settingsTitle => 'Settings';
  @override String get settingsSectionDateDisplay => 'Date & display';
  @override String get settingsHomeCardOrderTitle => 'Primary / secondary line on home cards';
  @override String get settingsHomeCardOrderSubtitle => 'Which line shows first';
  @override String get settingsSolarFirst => 'Gregorian first';
  @override String get settingsLunarFirst => 'Lunar first';
  @override String get settingsSectionNotify => 'Notifications';
  @override String get settingsNotifyMasterTitle => 'Notifications master switch';
  @override String get settingsNotifyMasterSubtitle => 'When off, no new reminders';
  @override String get settingsSectionHabitWidget => 'Habit & widget';
  @override String get settingsWidgetModeTitle => 'Widget mode';
  @override String get settingsWidgetModeNearest => 'Nearest';
  @override String get settingsWidgetModeTodayFirst => 'Today first';
  @override String get settingsWidgetModePinnedFirst => 'Pinned first';
  @override String get settingsDailyDigestTitle => 'Digest';
  @override String get settingsDailyDigestSubtitle => 'Digest subtitle';
  @override String get settingsDailyDigestTime => 'Digest time';
  @override String get notifDigestChannelName => 'Digest channel';
  @override String get notifDigestChannelDescription => 'Digest channel desc';
  @override String get notifDigestTitle => 'Digest title';
  @override String notifDigestBody(int count) => '$count items';
  @override String get settingsSectionLegal => 'Legal & help';
  @override String get settingsPrivacy => 'Privacy policy';
  @override String get settingsTerms => 'Terms of service';
  @override String get settingsFeedback => 'Feedback';
  @override String get settingsSectionAbout => 'About';
  @override String get settingsAboutApp => 'About 吉辰万年历';
  @override String settingsVersion(String version) => 'Version $version';
  @override String get settingsAboutBlurb => 'Important date reminders.';
  @override String get settingsSectionLanguage => 'Language';
  @override String get settingsLanguageEnglish => 'English';
  @override String get settingsLanguageChinese => '简体中文';
  @override String get copyrightLegalese => '© 2026';

  // --- Navigation ---
  @override String get navCountdownDay => 'Countdown';
  @override String get navCountdownBook => 'Countdown book';
  @override String get navHistoryToday => 'Today in history';
  @override String get navProfile => 'Profile';
  @override String get sidePanelGuest => 'Local user';
  @override String get sidePanelOpenSettings => 'Open settings';

  // --- App bar ---
  @override String get appBarTitleDays => '吉辰万年历 · Countdown';
  @override String get appBarTitleBook => 'Countdown book';
  @override String get appBarTitleHistory => 'Today in history';
  @override String get appBarTitleProfile => 'Profile';
  @override String get appBarTitleDefault => '吉辰万年历';
  @override String appBarFiltered(String label) => '吉辰万年历 · $label only';

  // --- Delete dialogs ---
  @override String get deleteEventTitle => 'Delete event?';
  @override String deleteEventBody(String title) => '「$title」will be permanently deleted.';
  @override String get deleteCategoryTitle => 'Delete category?';
  @override String deleteCategoryBody(String name) => 'Remove "$name".';
  @override String get emptyEventsFiltered => 'No events in this category.';
  @override String get emptyEvents => 'No events yet. Tap + to add.';
  @override String get searchEventsHint => 'Search events...';
  @override String get searchClearTooltip => 'Clear search';
  @override String get dashboardQuickPickAll => 'All';
  @override String get dashboardQuickPickSectionHint => 'Hint';
  @override String get dashboardSearchKeywordHint => 'Keyword';
  @override String get dashboardSearchPanelOpen => 'Search';
  @override String get dashboardSearchPanelClose => 'Hide';
  @override String get dashboardSearchActiveBadge => 'On';
  @override String get todaySummaryTitle => 'Today';
  @override String get todaySummaryEmpty => 'No events in window.';
  @override String get todaySummaryCreateEvent => 'Create event';
  @override String get todaySummaryShowAllCategories => 'All categories';
  @override String get todaySummaryOnlyCurrentCategory => 'Match filter';
  @override String get dashboardTodaySummaryButton => 'Today';
  @override String get emptySearchResults => 'No matching events found.';
  @override String get onboardingHint => 'Create an event and pick a category';
  @override String get addCategoryTitle => 'Add category';
  @override String get categoryNameLabel => 'Name';
  @override String get categoryIconLabel => 'Icon (emoji)';
  @override String get filterByCategory => 'Browse by category';
  @override String get tooltipAddCategory => 'Add category';
  @override String get sectionCategoryShelf => 'Category shelf';
  @override String get sectionListFilter => 'List & filter';
  @override String get sectionTools => 'Tools';
  @override String get toolDateCalculator => 'Date calculator';
  @override String get toolMilestone => 'Milestones';
  @override String get allEvents => 'All events';
  @override String get tooltipDeleteCategory => 'Delete category';
  @override String get newEvent => 'New event';
  @override String eventCount(int count) => '$count items';
  @override String get archiveTitle => 'Archive & hide';
  @override String get archivePlaceholder => 'Archive is coming soon.';

  // --- History ---
  @override String get historySampleData => 'Showing sample data (offline).';
  @override String get historyWikimedia => 'Entries from Wikimedia projects.';
  @override String get historySupabaseAi => 'Includes Supabase AI supplement.';
  @override String get historyIdaily => 'iDaily global view';
  @override String get historyExploreTagline => 'Explore today in history.';
  @override String get historyHoliday => 'Holidays';
  @override String get historyEvents => 'Historical events';
  @override String get historyEmptySupabase => 'No data. Pull to refresh.';
  @override String get historyEmpty => 'No data. Pull to refresh.';
  @override String get dashboardTodayFocus => 'Today focus';
  @override String dashboardDaysLeft(int days) => '$days days';
  @override String dashboardSelectedCount(int count) => '$count selected';
  @override String get dashboardCancelSelection => 'Cancel selection';
  @override String get dashboardBatchMarkCompleted => 'Mark completed';
  @override String get dashboardBatchArchive => 'Batch archive';
  @override String get dashboardBatchUpdateCategory => 'Batch category';
  @override String get dashboardBatchCategoryTitle => 'Batch update category';
  @override String get dashboardBatchUpdateReminder => 'Batch reminder';
  @override String get dashboardBatchReminderTitle => 'Batch update reminder preset';
  @override String get dashboardFilterAll => 'All';
  @override String get dashboardFilterActive => 'Active';
  @override String get dashboardFilterCompleted => 'Completed';
  @override String historyYearReviewTitle(String year) => '$year Year review';
  @override String get historySummaryTotal => 'Total';
  @override String get historySummaryActive => 'Active';
  @override String get historySummaryCompleted => 'Completed';
  @override String get historySummaryArchived => 'Archived';
  @override String get historyCompletionRate => 'Completion rate';
  @override String get historyCategoryRatio => 'Category ratio';
  @override String get historyArchivedEvents => 'Archived events';
  @override String historyArchivedCount(String count) => '$count items';
  @override String get historyArchivedEmpty => 'No archived events';
  @override String get historyRestore => 'Restore';
  @override String get historyDelete => 'Delete';

  // --- Profile ---
  @override String get profileSectionCommon => 'Common';
  @override String get profileSettings => 'Settings';
  @override String get profileFeedback => 'Feedback';
  @override String get profileAccountSecurity => 'Account & security';
  @override String get profileExportPng => 'Export as image';
  @override String get toastExportOk => 'Image generated.';
  @override String get toastExportEmpty => 'No events to export';
  @override String get profileSectionAboutAccount => 'About & account';
  @override String get profilePrivacy => 'Privacy policy';
  @override String get profileLogout => 'Log out';
  @override String get profileDeleteAccount => 'Delete account';
  @override String get profileDeleteAccountConfirmTitle => 'Request account deletion';
  @override String get profileDeleteAccountConfirmBody => 'After confirmation, your mail app will open.';
  @override String get profileDeleteAccountEmailSubject => '吉辰万年历 account deletion request';
  @override String get profileDeleteAccountEmailFallback => 'Cannot open mail app.';

  // --- Milestone ---
  @override String get milestoneTitle => 'Milestones';
  @override String get milestoneEmpty => 'No events yet.';
  @override String get milestoneSubtitle => 'Your events by distance from today.';
  @override String get milestoneSection7d => 'Within 7 days';
  @override String get milestoneSection30d => '8–30 days';
  @override String get milestoneSectionFar => 'Farther';
  @override String milestoneCardDesc(String cat, String dateLine, String dist, String label) =>
      '$cat · $dateLine · $dist days from today · $label';
  @override String get milestoneReached => 'Milestone reached!';
  @override String get milestoneApproaching => 'Milestone approaching';

  // --- Date calculator ---
  @override String get dateCalcTitle => 'Date calculator';
  @override String get dateCalcTabInterval => 'Interval';
  @override String get dateCalcTabShift => 'Shift date';
  @override String get dateCalcStartLunarPicker => 'Start date (lunar picker)';
  @override String get dateCalcStart => 'Start date';
  @override String get dateCalcEndLunarPicker => 'End date (lunar picker)';
  @override String get dateCalcEnd => 'End date';
  @override String get dateCalcInclusive => 'Include start & end';
  @override String get dateCalcCompute => 'Calculate';
  @override String dateCalcIntervalDays(int n) => 'Interval: $n days';
  @override String dateCalcStartLine(String date) => 'Start: $date';
  @override String dateCalcLunarLine(String lunar) => 'Lunar: $lunar';
  @override String dateCalcEndLine(String date) => 'End: $date';
  @override String get dateCalcBaseLunarPicker => 'Base date (lunar picker)';
  @override String get dateCalcBase => 'Base date';
  @override String get dateCalcDaysLabel => 'Days';
  @override String get dateCalcDaysHint => 'Integer';
  @override String get dateCalcBefore => 'N days before';
  @override String get dateCalcAfter => 'N days after';
  @override String get dateCalcResult => 'Result';
  @override String dateCalcGregorianLine(String date) => 'Gregorian: $date';

  // --- Login ---
  @override String get loginTitleSignIn => 'Sign in';
  @override String get loginTitleSignUp => 'Sign up';
  @override String get loginEmail => 'Email';
  @override String get loginPassword => 'Password';
  @override String get loginCtaEnter => 'Sign in & go to home';
  @override String get loginCtaRegister => 'Register & go to home';
  @override String get loginSwitchToSignIn => 'Have an account? Sign in';
  @override String get loginSwitchToSignUp => 'No account? Register';
  @override String get loginSupabaseMissing => 'Supabase not configured.';
  @override String get loginDemo => 'Demo sign-in & go to home';

  // --- Event detail ---
  @override String get eventDetailTitle => 'Event';
  @override String get eventDetailNotFound => 'Event not found or list out of sync.';
  @override String get eventDetailNotifyOff => 'Off';
  @override String eventDetailNotifyOn(String time) => 'On · $time';
  @override String get eventDetailDeleteTitle => 'Delete event?';
  @override String get eventDetailDeleteBody => 'This cannot be undone.';
  @override String get eventDetailTargetDate => 'Target date';
  @override String get eventDetailLunar => 'Lunar';
  @override String get eventDetailMode => 'Mode';
  @override String get eventDetailModeCountdown => 'Countdown';
  @override String get eventDetailModeElapsed => 'Elapsed';
  @override String get eventDetailReminder => 'Reminder';

  // --- Kling ---
  @override String get klingLoading => 'Loading…';

  // --- Legal ---
  @override String get legalPrivacyTitle => 'Privacy policy';
  @override String get legalTermsTitle => 'Terms of service';
  @override String get legalPrivacyBody => 'Full text is shown in-app.';
  @override String get legalTermsBody => 'Full text is shown in-app.';
  @override String get legalMdLoadError => 'Could not load the document.';
  @override String get legalConsentTitle => 'Welcome to 吉辰万年历';
  @override String get legalConsentMessage => 'To continue, please read and agree.';
  @override String get legalConsentAgree => 'Agree and continue';
  @override String get legalConsentDisagree => 'Disagree and exit';
  @override String get legalConsentViewTerms => 'View terms of service';
  @override String get legalConsentViewPrivacy => 'View privacy policy';

  // --- Account ---
  @override String get accountSecurityTitle => 'Account & security';
  @override String get accountLoginPrompt => 'Sign in to edit nickname.';
  @override String get accountGoLogin => 'Sign in';
  @override String get accountUserId => 'User ID';
  @override String get accountEmail => 'Email';
  @override String get accountLoginMethod => 'Sign-in method';
  @override String get accountLoginMethodSupabase => 'Supabase email';
  @override String get accountNickname => 'Nickname';
  @override String get accountNicknameHint => 'Stored only in local profile';
  @override String get toastNicknameEmpty => 'Nickname cannot be empty';
  @override String get toastNicknameTooLong => 'Nickname max 32 characters';
  @override String get toastSaved => 'Saved';

  // --- Feedback ---
  @override String get feedbackTitle => 'Feedback';
  @override String get feedbackIntro => 'Choose a type and describe.';
  @override String get feedbackTypeLabel => 'Type';
  @override String get feedbackContentLabel => 'Details';
  @override String get feedbackContentHint => 'Steps, expected vs actual behavior';
  @override String get feedbackTypeFeature => 'Feature request';
  @override String get feedbackTypeBug => 'Bug report';
  @override String get feedbackTypeAccount => 'Account & sync';
  @override String get feedbackTypeOther => 'Other';
  @override String get toastFeedbackEmpty => 'Please enter feedback';
  @override String toastFeedbackTooLong(int max) => 'Content exceeds $max characters';
  @override String get toastFeedbackSavedLocal => 'Saved on device';

  // --- Permissions ---
  @override String get permNotifyMasterOffTitle => 'In-app notifications are off';
  @override String get permNotifyMasterOffBody => 'Turn on Notifications master switch first.';
  @override String get permGoEnable => 'Open Settings';
  @override String get permNeedSystemNotifyTitle => 'Notification permission needed';
  @override String get permNeedSystemNotifyBodyIos => 'Notifications are off.';
  @override String get permNeedSystemNotifyBodyGeneric => 'Notification permission is required.';
  @override String get permOpenSystemSettings => 'Open system settings';
  @override String get permNeedCalendarTitle => 'Calendar access needed';
  @override String get permNeedCalendarBodyIos => 'Calendar access denied.';
  @override String get permNeedCalendarBodyGeneric => 'Calendar access is needed.';
  @override String get permNeedRemindersTitle => 'Reminders access needed';
  @override String get permNeedRemindersBodyIos => 'Reminders denied.';
  @override String get permNeedRemindersBodyGeneric => 'Reminders access is needed.';
  @override String get permNotifyMasterOffSaveBody => 'Turn on the in-app notification switch.';
  @override String get permSaveWithoutReminder => 'Save without reminder';
  @override String get permNeedNotifyDetailTitle => 'Notification permission needed';
  @override String get permNeedNotifyDetailBodyIos => 'Notifications disabled.';
  @override String get permNeedNotifyDetailBodyGeneric => 'Grant notification permission.';

  // --- Toast messages ---
  @override String get toastEnterEventTitle => 'Please enter event title';
  @override String toastTitleMax(int max) => 'Title max $max characters';
  @override String get toastSaveFailed => 'Save failed.';
  @override String get toastSavedReminderPending => 'Saved. Reminder inactive.';
  @override String get toastAddedCalReminders => 'Added to Calendar & Reminders';
  @override String get toastAddedCalNoRemindersPerm => 'Added to Calendar; Reminders skipped.';
  @override String get toastAddedCalRemindersFail => 'Added to Calendar; Reminders failed.';
  @override String get toastAddedCal => 'Added to Calendar';
  @override String get toastCalNoPerm => 'Not written to Calendar.';
  @override String get toastCalWriteFail => 'Failed to write Calendar.';

  // --- Repeat & reminder ---
  @override String get repeatSingle => 'Once';
  @override String get repeatYearly => 'Yearly';
  @override String get repeatMonthly => 'Monthly';
  @override String get repeatWeekly => 'Weekly';
  @override String get repeatDaily => 'Daily';
  @override String get remindSameDay => 'Same day';
  @override String get remind1DayBefore => '1 day before';
  @override String get remind3DaysBefore => '3 days before';
  @override String get remind7DaysBefore => '7 days before';
  @override String remindNDaysBefore(Object n) => '$n days before';
  @override String get eventFormReminderRules => 'Reminder rules';
  @override String get eventFormRepeat => 'Repeat';
  @override String get eventFormTime => 'Time';
  @override String get eventFormAdvance => 'Advance notice';
  @override String get dropdownSameDay => 'Same day';
  @override String get dropdown1DayBefore => '1 day before';
  @override String get dropdown3DaysBefore => '3 days before';
  @override String get dropdown7DaysBefore => '7 days before';

  // --- Event form ---
  @override String get eventFormTitleEdit => 'Edit event';
  @override String get eventFormTitleCreate => 'Create event';
  @override String get eventFormSave => 'Save';
  @override String get eventFormNameLabel => 'Event name';
  @override String get eventFormNameHint => 'Name this important day';
  @override String get eventFormDate => 'Date';
  @override String get eventFormLunar => 'Lunar';
  @override String get eventFormCategory => 'Category';
  @override String get eventFormColorLabel => 'Color';
  @override String get eventFormColorReset => 'Reset';
  @override String get eventFormTimer => 'Mode';
  @override String get eventFormCountdown => 'Countdown';
  @override String get eventFormElapsed => 'Elapsed';
  @override String get eventFormReminder => 'Reminder';
  @override String get eventFormReminderHint => 'Checks in-app notification switch.';
  @override String get eventFormReminderConfigure => 'Tap to set repeat, time, and advance notice.';
  @override String get eventFormCalendarAfterSave => 'Add to system calendar after save';
  @override String get eventFormCalendarHint => 'Requests calendar permission.';
  @override String get eventFormRemindersIos => 'Also write to Reminders';
  @override String get eventFormRemindersIosHint => 'Requires Reminders permission.';
  @override String get eventFormReminderDetail => 'Reminder detail';
  @override String get eventFormReminderType => 'Reminder type';
  @override String get eventFormReminderSingle => 'Single';
  @override String get eventFormReminderDaily => 'Daily';
  @override String get eventFormReminderWeekly => 'Weekly';
  @override String get eventFormReminderMonthly => 'Monthly';
  @override String get eventFormReminderYearly => 'Yearly';
  @override String get eventFormHardDeadline => 'Hard deadline';
  @override String get eventFormHardDeadlineHint => 'Hint';
  @override String get eventFormApplyRhythm731 => 'Apply rhythm';
  @override String get eventFormRhythm731Applied => 'Applied';
  @override String get eventFormRhythm731Requires => 'Requires';
  @override String get eventDetailShare => 'Share';
  @override String get eventShareFilename => 'e.png';
  @override String get eventShareIcsFilename => 'e.ics';
  @override String get eventShareText => 'Share text';
  @override String get eventShareWebFallback => 'Web';

  // --- Network errors ---
  @override String get networkErrCancelled => 'Request cancelled';
  @override String get networkErrConnectionTimeout => 'Connection timed out';
  @override String get networkErrSendTimeout => 'Send timed out';
  @override String get networkErrReceiveTimeout => 'Response timed out';
  @override String get networkErr400 => 'Bad request';
  @override String get networkErr401 => 'Unauthorized';
  @override String get networkErr403 => 'Forbidden';
  @override String get networkErr404 => 'Cannot reach server';
  @override String get networkErr405 => 'Method not allowed';
  @override String get networkErr500 => 'Internal server error';
  @override String get networkErr502 => 'Bad gateway';
  @override String get networkErr503 => 'Service unavailable';
  @override String get networkErr505 => 'HTTP version not supported';
  @override String get networkErrUnknown => 'Unknown error';

  // --- Lunar picker ---
  @override String get lunarPickerTitle => 'Pick lunar date (approx. 1901–2049)';
  @override String get lunarLabelYear => 'Year';
  @override String get lunarLabelMonth => 'Month';
  @override String get lunarLabelDay => 'Day';
  @override String lunarInvalidDay(String error) => 'Invalid lunar date: $error';

  // --- Notifications ---
  @override String get notifChannelName => 'Event reminders';
  @override String get notifChannelDescription => '吉辰万年历';
  @override String notifBodyLine(String app, String title, String mode, String label) =>
      '[$app] $title ($mode): $label';

  // --- Calendar export ---
  @override String calExportNotesLine(String app, String mode, String cat) => '$app · $mode · $cat';
  @override String get exportErrLayoutIncomplete => 'Could not render image.';
  @override String get exportErrEncodeFail => 'Image encoding failed';
  @override String get exportShareFilename => 'jichen-events.png';
  @override String get exportShareText => '吉辰万年历 · event list export';
  @override String exportFailWithError(String error) => 'Export failed: $error';
  @override String get exportListSubtitle => 'Event list · image export';
  @override String get exportTimeLabel => 'Exported at';
  @override String exportMetaTotalSorted(int count) => '$count events · sorted nearest to today first';
  @override String exportSolarLine(String line) => 'Gregorian: $line';
  @override String exportLunarLine(String line) => 'Lunar: $line';
  @override String exportTypeCategoryLine(String type, String cat) => 'Type: $type · Category: $cat';
  @override String get exportTypeCountdownShort => 'Countdown';
  @override String get exportTypeCountupShort => 'Elapsed';
  @override String exportTruncatedNote(int total, int limit) => '$total events total · only the first $limit are shown';
  @override String get exportFooterTagline => '吉辰万年历 · remember every day that matters';
  @override String get exportSummaryCdToday => 'Countdown · Today';
  @override String get exportSummaryCdPast => 'Countdown · target date passed';
  @override String exportSummaryCdRemain(int n) => 'Countdown · $n days left';
  @override String get exportSummaryCuFirst => 'Elapsed · start day (day 1)';
  @override String exportSummaryCuNth(int n) => 'Elapsed · day $n';
  @override String get exportHeroToday => 'Today';
  @override String get exportHeroFirstDay => 'Day 1';
  @override String get exportHeroUnitDay => 'days';
  @override String get exportCountupPrefix => 'Day ';
  @override String get exportCountupSuffix => '';

  // --- Categories ---
  @override String get categoryMemorial => 'Anniversary';
  @override String get categoryWork => 'Work';
  @override String get categoryLife => 'Life';

  // --- Builtin events ---
  @override String get builtinEventNextSaturday => 'Until Saturday';
  @override String get builtinEventYearEnd => 'Until year end';
  @override String get builtinEventAppleFounded => 'Apple founded';

// --- Day labels (dayLabelToday + dayLabelCountupFirst are interface members) ---
  @override String get dayLabelToday => 'Today';
  @override String get dayLabelCountupFirst => 'Day 1';
  String get dayLabelTomorrow => 'Tomorrow';
  String get dayLabelYesterday => 'Yesterday';
  String get dayLabelLastDays => 'Last 7 days';
  String get dayLabelThisMonth => 'This month';
  String get dayLabelThisYear => 'This year';
  String get dayLabelFuture => 'Future';
  String get dayLabelOlder => 'Older';
  String get dayLabelDaysAgo => 'days ago';
  String get dayLabelTodayCountup => 'Today is Day 1';
  String get dayLabelInDays => 'in %s days';
  String get dayLabelDaysSince => '%s days ago';
  String get dayLabelYearsMonthsDays => '%s years %s months %s days';
  String get dayLabelYearsDays => '%s years %s days';
  String get dayLabelMonthsDays => '%s months %s days';
  String get dayLabelJustNow => 'Just now';
  String get dayLabelHoursAgo => '%s hours ago';
  String get dayLabelDaysAgoAccurate => '%s days ago';
  String get dayLabelFutureDays => '%s days';
  String get dayLabelUpcoming => 'Upcoming';
  String get dayLabelCompleted => 'Completed';
  String get dayLabelRepeatYearly => 'Yearly';
  String get dayLabelRepeatMonthly => 'Monthly';
  String get dayLabelRepeatWeekly => 'Weekly';
  String get dayLabelRepeatDaily => 'Daily';
  String get dayLabelNoRepeat => 'No repeat';
  String get dayLabelAtDay => 'Day %s';
  String get dayLabelAtHour => 'at %s';
  String get dayLabelEveryYear => 'Every year';
  String get dayLabelEveryMonth => 'Every month';
  String get dayLabelEveryWeek => 'Every week';
  String get dayLabelEveryDay => 'Every day';
  String get dayLabelTillEvent => '%s days till';
  String get dayLabelSinceEvent => '%s days since';
  String get dayLabelUntilTomorrow => 'Until tomorrow';
  String get dayLabelStartingFrom => 'Starting from today';
  String get anniversaryLabelYears => '%s years';
  String get anniversaryLabelYear => 'year';
  String get eventLabelDaysRemaining => 'days remaining';
  String get eventLabelDaysPassed => 'days passed';
  String get countdownFutureLabel => 'Countdown to %s';
  String get countdownPastLabel => 'Countdown since %s';
  String get milestoneReachedLabel => 'Milestone reached!';
  String get milestoneApproachingLabel => 'Milestone approaching';
  String get noEventsThisPeriod => 'No events this period';

  // --- Repo errors ---
  @override String get repoErrNotLoggedInList => 'Not signed in or session expired.';
  @override String get repoErrNotLoggedInWrite => 'Not signed in or session expired.';
  @override String get repoErrNotLoggedIn => 'Not signed in or session expired.';
  @override String get repoErrLocalDupId => 'Local data error: duplicate ID.';
  @override String get repoErrLocalNotFound => 'Event not found locally.';
  @override String get repoErrDbSchema => 'Database schema mismatch.';

  // --- Locale (required by Intl_locale.dart base class) ---
  @override final String localeName = 'en';

  // --- Stub implementations for interface members used in tests ---
  // (milestoneReached already defined at line 161)
}

void main() {
  const mockL10n = MockAppLocalizations();

  group('daysDistanceFromToday', () {
    test('returns 0 for today', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      expect(daysDistanceFromToday(iso), 0);
    });

    test('returns positive distance for future dates', () {
      final future = DateTime.now().add(const Duration(days: 10));
      final iso = DateTime.utc(future.year, future.month, future.day).toIso8601String();
      expect(daysDistanceFromToday(iso), 10);
    });

    test('returns positive distance for past dates (absolute value)', () {
      final past = DateTime.now().subtract(const Duration(days: 5));
      final iso = DateTime.utc(past.year, past.month, past.day).toIso8601String();
      expect(daysDistanceFromToday(iso), 5);
    });
  });

  group('dayDisplayLabelLocalized (countdown)', () {
    test('returns dayLabelToday for today', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      final label = dayDisplayLabelLocalized(iso, DayEventType.countdown, mockL10n);
      expect(label, 'Today');
    });

    test('returns positive number for future countdown', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final iso = DateTime.utc(future.year, future.month, future.day).toIso8601String();
      final label = dayDisplayLabelLocalized(iso, DayEventType.countdown, mockL10n);
      expect(label, '5');
    });

    test('returns elapsed days for past countdown (fixed behavior)', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      final iso = DateTime.utc(past.year, past.month, past.day).toIso8601String();
      final label = dayDisplayLabelLocalized(iso, DayEventType.countdown, mockL10n);
      // Past countdown should show elapsed days (3), not '0'
      expect(label, '3');
    });

    test('yesterday countdown shows "1" (1 day elapsed)', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final iso = DateTime.utc(yesterday.year, yesterday.month, yesterday.day).toIso8601String();
      final label = dayDisplayLabelLocalized(iso, DayEventType.countdown, mockL10n);
      expect(label, '1');
    });
  });

  group('isSpecialDayLabel', () {
    test('true for today countdown', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      expect(isSpecialDayLabel(iso, DayEventType.countdown), true);
    });

    test('true for today countup', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      expect(isSpecialDayLabel(iso, DayEventType.countup), true);
    });

    test('false for yesterday countdown', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final iso = DateTime.utc(yesterday.year, yesterday.month, yesterday.day).toIso8601String();
      expect(isSpecialDayLabel(iso, DayEventType.countdown), false);
    });

    test('false for tomorrow countdown', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final iso = DateTime.utc(tomorrow.year, tomorrow.month, tomorrow.day).toIso8601String();
      expect(isSpecialDayLabel(iso, DayEventType.countdown), false);
    });
  });

  group('calculateDays', () {
    test('countdown today returns 0', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      expect(calculateDays(iso, DayEventType.countdown), 0);
    });

    test('countdown future 5 days returns 5', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final iso = DateTime.utc(future.year, future.month, future.day).toIso8601String();
      expect(calculateDays(iso, DayEventType.countdown), 5);
    });

    test('countdown past caps at 0 (no negative)', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      final iso = DateTime.utc(past.year, past.month, past.day).toIso8601String();
      // Past countdown caps at 0 — already passed dates don't show negative
      expect(calculateDays(iso, DayEventType.countdown), 0);
    });

    test('countup today returns 0 (Day 1 shown via label, not days)', () {
      final today = DateTime.now();
      final iso = DateTime.utc(today.year, today.month, today.day).toIso8601String();
      expect(calculateDays(iso, DayEventType.countup), 0);
    });

    test('countup past 3 days returns 3', () {
      final past = DateTime.now().subtract(const Duration(days: 3));
      final iso = DateTime.utc(past.year, past.month, past.day).toIso8601String();
      expect(calculateDays(iso, DayEventType.countup), 3);
    });

    test('countup future returns 0 (elapsed only)', () {
      final future = DateTime.now().add(const Duration(days: 5));
      final iso = DateTime.utc(future.year, future.month, future.day).toIso8601String();
      expect(calculateDays(iso, DayEventType.countup), 0);
    });
  });

  group('milestone', () {
    test('calculateMilestone returns 1000 for 1000 days', () {
      expect(calculateMilestone(1000), 1000);
    });

    test('calculateMilestone returns 365 for 1 year', () {
      expect(calculateMilestone(365), 365);
    });

    test('milestoneReached returns milestone achieved when inDays >= milestone', () {
      expect(milestoneReached(mockL10n, 100, 100), 'Milestone reached!');
      expect(milestoneReached(mockL10n, 100, 150), 'Milestone reached!');
    });

    test('milestoneReached returns null when not reached', () {
      expect(milestoneReached(mockL10n, 100, 50), null);
    });
  });
}
