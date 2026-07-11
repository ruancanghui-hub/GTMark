// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '吉辰万年历';

  @override
  String get appNameShort => '吉辰万年历';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonOk => 'OK';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundBackHome => 'Back to home';

  @override
  String get splashTagline => 'Calendar · lucky days · reminders · blessings';

  @override
  String get splashMessage =>
      'See solar and lunar dates, pick auspicious days, and never miss what matters.';

  @override
  String get splashLoading => 'Loading…';

  @override
  String get splashVideoUnavailable => 'Video unavailable';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionDateDisplay => 'Date & display';

  @override
  String get settingsHomeCardOrderTitle =>
      'Primary / secondary line on home cards';

  @override
  String get settingsHomeCardOrderSubtitle =>
      'Which line shows first: Gregorian or lunar';

  @override
  String get settingsSolarFirst => 'Gregorian first';

  @override
  String get settingsLunarFirst => 'Lunar first';

  @override
  String get settingsSectionNotify => 'Notifications';

  @override
  String get settingsNotifyMasterTitle => 'Notifications master switch';

  @override
  String get settingsNotifyMasterSubtitle =>
      'When off, no new reminders are scheduled (saved reminder settings remain).';

  @override
  String get settingsSectionHabitWidget => 'Habit & home screen widget';

  @override
  String get settingsWidgetModeTitle => 'Widget primary event';

  @override
  String get settingsWidgetModeNearest => 'Soonest deadline';

  @override
  String get settingsWidgetModeTodayFirst => 'First row of Today list';

  @override
  String get settingsWidgetModePinnedFirst =>
      'Pinned in 7-day window, else soonest';

  @override
  String get settingsDailyDigestTitle => 'Daily summary notification';

  @override
  String get settingsDailyDigestSubtitle =>
      'At most once per day when enabled. Requires notifications on.';

  @override
  String get settingsDailyDigestTime => 'Summary time';

  @override
  String get notifDigestChannelName => 'Daily summary';

  @override
  String get notifDigestChannelDescription =>
      'At most one summary per day when enabled in settings.';

  @override
  String get notifDigestTitle => 'Today';

  @override
  String notifDigestBody(int count) {
    return '$count countdown(s) in the next 7 days.';
  }

  @override
  String get settingsSectionLegal => 'Legal & help';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of service';

  @override
  String get settingsFeedback => 'Feedback';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsAboutApp => 'About LuckyDate';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutBlurb =>
      'Important date reminders and local notifications. When you sign in with email, events sync to your configured cloud.';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get copyrightLegalese => '© 2026';

  @override
  String get navCountdownDay => 'Countdown';

  @override
  String get navCountdownBook => 'Countdown book';

  @override
  String get navHistoryToday => 'Today in history';

  @override
  String get navProfile => 'Profile';

  @override
  String get sidePanelGuest => 'Local user';

  @override
  String get sidePanelOpenSettings => 'Open settings';

  @override
  String get appBarTitleDays => 'LuckyDate · Countdown';

  @override
  String get appBarTitleBook => 'Countdown book';

  @override
  String get appBarTitleHistory => 'Today in history';

  @override
  String get appBarTitleProfile => 'Profile';

  @override
  String get appBarTitleDefault => 'LuckyDate';

  @override
  String appBarFiltered(String label) {
    return 'LuckyDate · $label only';
  }

  @override
  String get deleteEventTitle => 'Delete event?';

  @override
  String deleteEventBody(String title) {
    return '「$title」will be permanently deleted.';
  }

  @override
  String get deleteCategoryTitle => 'Delete category?';

  @override
  String deleteCategoryBody(String name) {
    return 'Remove \"$name\". You can only delete when it has no events.';
  }

  @override
  String get emptyEventsFiltered =>
      'No events in this category. Tap + or change filter.';

  @override
  String get emptyEvents => 'No events yet. Tap + to add.';

  @override
  String get searchEventsHint => 'Search events...';

  @override
  String get searchClearTooltip => 'Clear search';

  @override
  String get dashboardQuickPickAll => 'All';

  @override
  String get dashboardQuickPickSectionHint =>
      'Tap a name to filter quickly. You can still type a keyword below.';

  @override
  String get dashboardSearchKeywordHint => 'Keyword';

  @override
  String get dashboardSearchPanelOpen => 'Search & filter';

  @override
  String get dashboardSearchPanelClose => 'Hide search';

  @override
  String get dashboardSearchActiveBadge => 'On';

  @override
  String get todaySummaryTitle => 'Today';

  @override
  String get todaySummaryEmpty =>
      'No countdown events in the next 7 days (including today).';

  @override
  String get todaySummaryCreateEvent => 'Create event';

  @override
  String get todaySummaryShowAllCategories => 'All categories';

  @override
  String get todaySummaryOnlyCurrentCategory => 'Match home category filter';

  @override
  String get dashboardTodaySummaryButton => 'Today';

  @override
  String get emptySearchResults => 'No matching events found.';

  @override
  String get onboardingHint => 'Create an event and pick a category';

  @override
  String get addCategoryTitle => 'Add category';

  @override
  String get categoryNameLabel => 'Name';

  @override
  String get categoryIconLabel => 'Icon (emoji)';

  @override
  String get filterByCategory => 'Browse by category';

  @override
  String get tooltipAddCategory => 'Add category';

  @override
  String get sectionCategoryShelf => 'Category shelf';

  @override
  String get sectionListFilter => 'List & filter';

  @override
  String get sectionTools => 'Tools';

  @override
  String get toolDateCalculator => 'Date calculator';

  @override
  String get toolMilestone => 'Milestones';

  @override
  String get allEvents => 'All events';

  @override
  String get tooltipDeleteCategory => 'Delete category';

  @override
  String get newEvent => 'New event';

  @override
  String eventCount(int count) {
    return '$count items';
  }

  @override
  String get archiveTitle => 'Archive & hide';

  @override
  String get archivePlaceholder => 'Archive is coming soon.';

  @override
  String get historySampleData =>
      'Showing sample data (offline or no cache for this day).';

  @override
  String get historyWikimedia => 'Entries from Wikimedia projects.';

  @override
  String get historySupabaseAi => 'Includes Supabase AI supplement.';

  @override
  String get historyIdaily => 'iDaily global view';

  @override
  String get historyExploreTagline => 'Explore today in history.';

  @override
  String get historyHoliday => 'Holidays';

  @override
  String get historyEvents => 'Historical events';

  @override
  String get historyEmptySupabase =>
      'No data. Pull to refresh or try again (Wikimedia API needs network). With Supabase, AI merge is attempted.';

  @override
  String get historyEmpty =>
      'No data. Pull to refresh (Wikimedia API needs network).';

  @override
  String get dashboardTodayFocus => 'Today focus';

  @override
  String dashboardDaysLeft(int days) {
    return '$days days';
  }

  @override
  String dashboardSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get dashboardCancelSelection => 'Cancel selection';

  @override
  String get dashboardBatchMarkCompleted => 'Mark completed';

  @override
  String get dashboardBatchArchive => 'Batch archive';

  @override
  String get dashboardBatchUpdateCategory => 'Batch category';

  @override
  String get dashboardBatchCategoryTitle => 'Batch update category';

  @override
  String get dashboardBatchUpdateReminder => 'Batch reminder';

  @override
  String get dashboardBatchReminderTitle => 'Batch update reminder preset';

  @override
  String get dashboardFilterAll => 'All';

  @override
  String get dashboardFilterActive => 'Active';

  @override
  String get dashboardFilterCompleted => 'Completed';

  @override
  String historyYearReviewTitle(String year) {
    return '$year Year review';
  }

  @override
  String get historySummaryTotal => 'Total';

  @override
  String get historySummaryActive => 'Active';

  @override
  String get historySummaryCompleted => 'Completed';

  @override
  String get historySummaryArchived => 'Archived';

  @override
  String get historyCompletionRate => 'Completion rate';

  @override
  String get historyCategoryRatio => 'Category ratio';

  @override
  String get historyArchivedEvents => 'Archived events';

  @override
  String historyArchivedCount(String count) {
    return '$count items';
  }

  @override
  String get historyArchivedEmpty => 'No archived events';

  @override
  String get historyRestore => 'Restore';

  @override
  String get historyDelete => 'Delete';

  @override
  String get profileSectionCommon => 'Common';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileFeedback => 'Feedback';

  @override
  String get profileAccountSecurity => 'Account & security';

  @override
  String get profileExportPng => 'Export as image';

  @override
  String get toastExportOk =>
      'Image generated. Save or share from the share sheet.';

  @override
  String get toastExportEmpty => 'No events to export';

  @override
  String get profileSectionAboutAccount => 'About & account';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteAccountConfirmTitle => 'Request account deletion';

  @override
  String get profileDeleteAccountConfirmBody =>
      'After confirmation, your mail app will open to send a deletion request to support.';

  @override
  String get profileDeleteAccountEmailSubject =>
      'LuckyDate account deletion request';

  @override
  String get profileDeleteAccountEmailFallback =>
      'Cannot open mail app. Please send an email to ruancanghui@163.com.';

  @override
  String get milestoneTitle => 'Milestones';

  @override
  String get milestoneEmpty => 'No events yet. Create one on the home tab.';

  @override
  String get milestoneSubtitle =>
      'Your events by distance from today (nearest first).';

  @override
  String get milestoneSection7d => '1–7 days';

  @override
  String get milestoneSection30d => '8–30 days';

  @override
  String get milestoneSectionFar => 'Farther';

  @override
  String milestoneCardDesc(
    String cat,
    String dateLine,
    String dist,
    String label,
  ) {
    return '$cat · $dateLine · $dist days from today · $label';
  }

  @override
  String get milestoneReached => 'Milestone reached!';

  @override
  String get milestoneApproaching => 'Milestone approaching';

  @override
  String get dateCalcTitle => 'Date calculator';

  @override
  String get dateCalcTabInterval => 'Interval';

  @override
  String get dateCalcTabShift => 'Shift date';

  @override
  String get dateCalcStartLunarPicker => 'Start date (lunar picker)';

  @override
  String get dateCalcStart => 'Start date';

  @override
  String get dateCalcEndLunarPicker => 'End date (lunar picker)';

  @override
  String get dateCalcEnd => 'End date';

  @override
  String get dateCalcInclusive => 'Include start & end';

  @override
  String get dateCalcCompute => 'Calculate';

  @override
  String dateCalcIntervalDays(int n) {
    return 'Interval: $n days';
  }

  @override
  String dateCalcStartLine(String date) {
    return 'Start: $date';
  }

  @override
  String dateCalcLunarLine(String lunar) {
    return 'Lunar: $lunar';
  }

  @override
  String dateCalcEndLine(String date) {
    return 'End: $date';
  }

  @override
  String get dateCalcBaseLunarPicker => 'Base date (lunar picker)';

  @override
  String get dateCalcBase => 'Base date';

  @override
  String get dateCalcDaysLabel => 'Days';

  @override
  String get dateCalcDaysHint => 'Integer';

  @override
  String get dateCalcBefore => 'N days before';

  @override
  String get dateCalcAfter => 'N days after';

  @override
  String get dateCalcResult => 'Result';

  @override
  String dateCalcGregorianLine(String date) {
    return 'Gregorian: $date';
  }

  @override
  String get loginTitleSignIn => 'Sign in';

  @override
  String get loginTitleSignUp => 'Sign up';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginCtaEnter => 'Sign in & go to home';

  @override
  String get loginCtaRegister => 'Register & go to home';

  @override
  String get loginSwitchToSignIn => 'Have an account? Sign in';

  @override
  String get loginSwitchToSignUp => 'No account? Register';

  @override
  String get loginSupabaseMissing =>
      'Supabase not configured (SUPABASE_URL / SUPABASE_ANON_KEY). Demo sign-in; events won\'t sync to cloud.';

  @override
  String get loginDemo => 'Demo sign-in & go to home';

  @override
  String get eventDetailTitle => 'Event';

  @override
  String get eventDetailNotFound => 'Event not found or list out of sync.';

  @override
  String get eventDetailNotifyOff => 'Off';

  @override
  String eventDetailNotifyOn(String time) {
    return 'On · $time';
  }

  @override
  String get eventDetailDeleteTitle => 'Delete event?';

  @override
  String get eventDetailDeleteBody => 'This cannot be undone.';

  @override
  String get eventDetailTargetDate => 'Target date';

  @override
  String get eventDetailLunar => 'Lunar';

  @override
  String get eventDetailMode => 'Mode';

  @override
  String get eventDetailModeCountdown => 'Countdown';

  @override
  String get eventDetailModeElapsed => 'Elapsed';

  @override
  String get eventDetailReminder => 'Reminder';

  @override
  String get klingLoading => 'Loading…';

  @override
  String get legalPrivacyTitle => 'Privacy policy';

  @override
  String get legalTermsTitle => 'Terms of service';

  @override
  String get legalPrivacyBody =>
      'Full text is shown in-app; we process data on a minimal-necessary basis—see the Markdown document for details.';

  @override
  String get legalTermsBody =>
      'Full text is shown in-app; by using the app you agree to the complete terms.';

  @override
  String get legalMdLoadError =>
      'Could not load the document. Please try again or restart the app.';

  @override
  String get legalConsentTitle => 'Welcome to 吉辰万年历';

  @override
  String get legalConsentMessage =>
      'To continue, please read and agree to the Terms of Service and Privacy Policy. Use the links below to read the full text; tap agree to enter the app.';

  @override
  String get legalConsentAgree => 'Agree and continue';

  @override
  String get legalConsentDisagree => 'Disagree and exit';

  @override
  String get legalConsentViewTerms => 'View terms of service';

  @override
  String get legalConsentViewPrivacy => 'View privacy policy';

  @override
  String get accountSecurityTitle => 'Account & security';

  @override
  String get accountLoginPrompt =>
      'Sign in to edit nickname and view account info.';

  @override
  String get accountGoLogin => 'Sign in';

  @override
  String get accountUserId => 'User ID';

  @override
  String get accountEmail => 'Email';

  @override
  String get accountLoginMethod => 'Sign-in method';

  @override
  String get accountLoginMethodSupabase => 'Supabase email';

  @override
  String get accountNickname => 'Nickname';

  @override
  String get accountNicknameHint => 'Stored only in local profile';

  @override
  String get toastNicknameEmpty => 'Nickname cannot be empty';

  @override
  String get toastNicknameTooLong => 'Nickname max 32 characters';

  @override
  String get toastSaved => 'Saved';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackIntro =>
      'Choose a type and describe the issue. Content is saved on this device only.';

  @override
  String get feedbackTypeLabel => 'Type';

  @override
  String get feedbackContentLabel => 'Details';

  @override
  String get feedbackContentHint => 'Steps, expected vs actual behavior';

  @override
  String get feedbackTypeFeature => 'Feature request';

  @override
  String get feedbackTypeBug => 'Bug report';

  @override
  String get feedbackTypeAccount => 'Account & sync';

  @override
  String get feedbackTypeOther => 'Other';

  @override
  String get toastFeedbackEmpty => 'Please enter feedback';

  @override
  String toastFeedbackTooLong(int max) {
    return 'Content exceeds $max characters';
  }

  @override
  String get toastFeedbackSavedLocal => 'Saved on device';

  @override
  String get permNotifyMasterOffTitle => 'In-app notifications are off';

  @override
  String get permNotifyMasterOffBody =>
      'Turn on \"Notifications master switch\" in Settings first.';

  @override
  String get permGoEnable => 'Open Settings';

  @override
  String get permNeedSystemNotifyTitle => 'Notification permission needed';

  @override
  String get permNeedSystemNotifyBodyIos =>
      'Notifications are off. Enable in Settings → LuckyDate → Notifications.';

  @override
  String get permNeedSystemNotifyBodyGeneric =>
      'Notification permission is required for reminders.';

  @override
  String get permOpenSystemSettings => 'Open system settings';

  @override
  String get permNeedCalendarTitle => 'Calendar access needed';

  @override
  String get permNeedCalendarBodyIos =>
      'Calendar access denied. Enable in Settings → LuckyDate.';

  @override
  String get permNeedCalendarBodyGeneric =>
      'Calendar access is needed to write events.';

  @override
  String get permNeedRemindersTitle => 'Reminders access needed';

  @override
  String get permNeedRemindersBodyIos =>
      'Reminders denied. Enable in Settings → LuckyDate.';

  @override
  String get permNeedRemindersBodyGeneric =>
      'Reminders access is needed to sync.';

  @override
  String get permNotifyMasterOffSaveBody =>
      'Turn on the in-app notification switch to schedule local reminders.\n\nYou can save the event and enable notifications later in Settings.';

  @override
  String get permSaveWithoutReminder => 'Save without reminder';

  @override
  String get permNeedNotifyDetailTitle => 'Notification permission needed';

  @override
  String get permNeedNotifyDetailBodyIos =>
      'Notifications disabled. Enable in Settings → LuckyDate → Notifications.';

  @override
  String get permNeedNotifyDetailBodyGeneric =>
      'Grant notification permission in system settings for local reminders.';

  @override
  String get toastEnterEventTitle => 'Please enter event title';

  @override
  String toastTitleMax(int max) {
    return 'Title max $max characters';
  }

  @override
  String get toastSaveFailed => 'Save failed. Check network or sign-in.';

  @override
  String get toastSavedReminderPending =>
      'Saved. Reminder inactive — enable in Settings or OS permissions, then edit this event.';

  @override
  String get toastAddedCalReminders => 'Added to Calendar & Reminders';

  @override
  String get toastAddedCalNoRemindersPerm =>
      'Added to Calendar; Reminders skipped (no permission)';

  @override
  String get toastAddedCalRemindersFail =>
      'Added to Calendar; Reminders failed, try again';

  @override
  String get toastAddedCal => 'Added to Calendar';

  @override
  String get toastCalNoPerm =>
      'Not written to Calendar — no permission. Enable in Settings.';

  @override
  String get toastCalWriteFail =>
      'Failed to write Calendar. Check permission or try again.';

  @override
  String get repeatSingle => 'Once';

  @override
  String get repeatYearly => 'Yearly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get remindSameDay => 'Same day';

  @override
  String get remind1DayBefore => '1 day before';

  @override
  String get remind3DaysBefore => '3 days before';

  @override
  String get remind7DaysBefore => '7 days before';

  @override
  String remindNDaysBefore(Object n) {
    return '$n days before';
  }

  @override
  String get eventFormReminderRules => 'Reminder rules';

  @override
  String get eventFormRepeat => 'Repeat';

  @override
  String get eventFormTime => 'Time';

  @override
  String get eventFormAdvance => 'Advance notice';

  @override
  String get dropdownSameDay => 'Same day';

  @override
  String get dropdown1DayBefore => '1 day before';

  @override
  String get dropdown3DaysBefore => '3 days before';

  @override
  String get dropdown7DaysBefore => '7 days before';

  @override
  String get commonDone => 'Done';

  @override
  String get eventFormTitleEdit => 'Edit event';

  @override
  String get eventFormTitleCreate => 'Create event';

  @override
  String get eventFormSave => 'Save';

  @override
  String get eventFormNameLabel => 'Event name';

  @override
  String get eventFormNameHint => 'Name this important day';

  @override
  String get eventFormDate => 'Date';

  @override
  String get eventFormLunar => 'Lunar';

  @override
  String get eventFormCategory => 'Category';

  @override
  String get eventFormColorLabel => 'Color';

  @override
  String get eventFormColorReset => 'Reset';

  @override
  String get eventFormTimer => 'Mode';

  @override
  String get eventFormCountdown => 'Countdown';

  @override
  String get eventFormElapsed => 'Elapsed';

  @override
  String get eventFormReminder => 'Reminder';

  @override
  String get eventFormReminderHint =>
      'Checks in-app notification switch and OS permission when enabled.';

  @override
  String get eventFormReminderConfigure =>
      'Tap to set repeat, time, and advance notice.';

  @override
  String get eventFormCalendarAfterSave => 'Add to system calendar after save';

  @override
  String get eventFormCalendarHint =>
      'Requests calendar permission; writes to Calendar on save (can work with in-app reminders).';

  @override
  String get eventFormRemindersIos => 'Also write to Reminders';

  @override
  String get eventFormRemindersIosHint =>
      'Requires Reminders permission; separate from in-app notifications.';

  @override
  String get eventFormReminderDetail => 'Reminder detail';

  @override
  String get eventFormReminderType => 'Repeat';

  @override
  String get eventFormReminderSingle => 'Once';

  @override
  String get eventFormReminderDaily => 'Daily';

  @override
  String get eventFormReminderWeekly => 'Weekly';

  @override
  String get eventFormReminderMonthly => 'Monthly';

  @override
  String get eventFormReminderYearly => 'Yearly';

  @override
  String get eventFormHardDeadline => 'Hard deadline';

  @override
  String get eventFormHardDeadlineHint =>
      'Emphasize in the list; optional 7/3/1 reminder rhythm for countdown (once).';

  @override
  String get eventFormApplyRhythm731 => 'Apply 7 / 3 / 1 day rhythm';

  @override
  String get eventFormRhythm731Applied => 'Rhythm will apply after you save';

  @override
  String get eventFormRhythm731Requires =>
      'Requires countdown, “Once” repeat, and reminder on';

  @override
  String get eventDetailShare => 'Share';

  @override
  String get eventShareFilename => 'jichen-event.png';

  @override
  String get eventShareIcsFilename => 'jichen-event.ics';

  @override
  String get eventShareText => 'LuckyDate · event';

  @override
  String get eventShareWebFallback =>
      'Sharing as text on web (image export is mobile/desktop).';

  @override
  String get networkErrCancelled => 'Request cancelled';

  @override
  String get networkErrConnectionTimeout => 'Connection timed out';

  @override
  String get networkErrSendTimeout => 'Send timed out';

  @override
  String get networkErrReceiveTimeout => 'Response timed out';

  @override
  String get networkErr400 => 'Bad request';

  @override
  String get networkErr401 => 'Unauthorized';

  @override
  String get networkErr403 => 'Forbidden';

  @override
  String get networkErr404 => 'Cannot reach server';

  @override
  String get networkErr405 => 'Method not allowed';

  @override
  String get networkErr500 => 'Internal server error';

  @override
  String get networkErr502 => 'Bad gateway';

  @override
  String get networkErr503 => 'Service unavailable';

  @override
  String get networkErr505 => 'HTTP version not supported';

  @override
  String get networkErrUnknown => 'Unknown error';

  @override
  String get lunarPickerTitle => 'Pick lunar date (approx. 1901–2049)';

  @override
  String get lunarLabelYear => 'Year';

  @override
  String get lunarLabelMonth => 'Month';

  @override
  String get lunarLabelDay => 'Day';

  @override
  String lunarInvalidDay(String error) {
    return 'Invalid lunar date: $error';
  }

  @override
  String get notifChannelName => 'Event reminders';

  @override
  String get notifChannelDescription => 'LuckyDate';

  @override
  String notifBodyLine(String app, String title, String mode, String label) {
    return '[$app] $title ($mode): $label';
  }

  @override
  String calExportNotesLine(String app, String mode, String cat) {
    return '$app · $mode · $cat';
  }

  @override
  String get exportErrLayoutIncomplete =>
      'Could not render image (layout not ready). Try again.';

  @override
  String get exportErrEncodeFail => 'Image encoding failed';

  @override
  String get exportShareFilename => 'jichen-events.png';

  @override
  String get exportShareText => 'LuckyDate · event list export';

  @override
  String exportFailWithError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get exportListSubtitle => 'Event list · image export';

  @override
  String get exportTimeLabel => 'Exported at';

  @override
  String exportMetaTotalSorted(int count) {
    return '$count events · sorted nearest to today first';
  }

  @override
  String exportSolarLine(String line) {
    return 'Gregorian: $line';
  }

  @override
  String exportLunarLine(String line) {
    return 'Lunar: $line';
  }

  @override
  String exportTypeCategoryLine(String type, String cat) {
    return 'Type: $type · Category: $cat';
  }

  @override
  String get exportTypeCountdownShort => 'Countdown';

  @override
  String get exportTypeCountupShort => 'Elapsed';

  @override
  String exportTruncatedNote(int total, int limit) {
    return '$total events total · only the first $limit are shown';
  }

  @override
  String get exportFooterTagline =>
      'LuckyDate · remember every day that matters';

  @override
  String get exportSummaryCdToday => 'Countdown · Today';

  @override
  String get exportSummaryCdPast => 'Countdown · target date passed';

  @override
  String exportSummaryCdRemain(int n) {
    return 'Countdown · $n days left';
  }

  @override
  String get exportSummaryCuFirst => 'Elapsed · start day (day 1)';

  @override
  String exportSummaryCuNth(int n) {
    return 'Elapsed · day $n';
  }

  @override
  String get exportHeroToday => 'Today';

  @override
  String get exportHeroFirstDay => 'Day 1';

  @override
  String get exportHeroUnitDay => 'days';

  @override
  String get exportCountupPrefix => 'Day ';

  @override
  String get exportCountupSuffix => '';

  @override
  String get categoryMemorial => 'Anniversary';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryLife => 'Life';

  @override
  String get builtinEventNextSaturday => 'Until Saturday';

  @override
  String get builtinEventYearEnd => 'Until year end';

  @override
  String get builtinEventAppleFounded => 'Apple founded';

  @override
  String get dayLabelToday => 'Today';

  @override
  String get dayLabelCountupFirst => 'Day 1';

  @override
  String get repoErrNotLoggedInList =>
      'Not signed in or session expired. Please sign in again.';

  @override
  String get repoErrNotLoggedInWrite =>
      'Not signed in or session expired. Cannot sync to cloud.';

  @override
  String get repoErrNotLoggedIn => 'Not signed in or session expired.';

  @override
  String get repoErrLocalDupId => 'Local data error: duplicate ID.';

  @override
  String get repoErrLocalNotFound => 'Event not found locally.';

  @override
  String get repoErrDbSchema =>
      'Database schema mismatch (e.g. missing reminder_json). Run migrations and retry.';
}
