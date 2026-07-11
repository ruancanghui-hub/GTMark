import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'吉辰万年历'**
  String get appTitle;

  /// No description provided for @appNameShort.
  ///
  /// In en, this message translates to:
  /// **'吉辰万年历'**
  String get appNameShort;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get notFoundBackHome;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Calendar · lucky days · reminders · blessings'**
  String get splashTagline;

  /// No description provided for @splashMessage.
  ///
  /// In en, this message translates to:
  /// **'See solar and lunar dates, pick auspicious days, and never miss what matters.'**
  String get splashMessage;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get splashLoading;

  /// No description provided for @splashVideoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video unavailable'**
  String get splashVideoUnavailable;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionDateDisplay.
  ///
  /// In en, this message translates to:
  /// **'Date & display'**
  String get settingsSectionDateDisplay;

  /// No description provided for @settingsHomeCardOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Primary / secondary line on home cards'**
  String get settingsHomeCardOrderTitle;

  /// No description provided for @settingsHomeCardOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Which line shows first: Gregorian or lunar'**
  String get settingsHomeCardOrderSubtitle;

  /// No description provided for @settingsSolarFirst.
  ///
  /// In en, this message translates to:
  /// **'Gregorian first'**
  String get settingsSolarFirst;

  /// No description provided for @settingsLunarFirst.
  ///
  /// In en, this message translates to:
  /// **'Lunar first'**
  String get settingsLunarFirst;

  /// No description provided for @settingsSectionNotify.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotify;

  /// No description provided for @settingsNotifyMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications master switch'**
  String get settingsNotifyMasterTitle;

  /// No description provided for @settingsNotifyMasterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, no new reminders are scheduled (saved reminder settings remain).'**
  String get settingsNotifyMasterSubtitle;

  /// No description provided for @settingsSectionHabitWidget.
  ///
  /// In en, this message translates to:
  /// **'Habit & home screen widget'**
  String get settingsSectionHabitWidget;

  /// No description provided for @settingsWidgetModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Widget primary event'**
  String get settingsWidgetModeTitle;

  /// No description provided for @settingsWidgetModeNearest.
  ///
  /// In en, this message translates to:
  /// **'Soonest deadline'**
  String get settingsWidgetModeNearest;

  /// No description provided for @settingsWidgetModeTodayFirst.
  ///
  /// In en, this message translates to:
  /// **'First row of Today list'**
  String get settingsWidgetModeTodayFirst;

  /// No description provided for @settingsWidgetModePinnedFirst.
  ///
  /// In en, this message translates to:
  /// **'Pinned in 7-day window, else soonest'**
  String get settingsWidgetModePinnedFirst;

  /// No description provided for @settingsDailyDigestTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily summary notification'**
  String get settingsDailyDigestTitle;

  /// No description provided for @settingsDailyDigestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'At most once per day when enabled. Requires notifications on.'**
  String get settingsDailyDigestSubtitle;

  /// No description provided for @settingsDailyDigestTime.
  ///
  /// In en, this message translates to:
  /// **'Summary time'**
  String get settingsDailyDigestTime;

  /// No description provided for @notifDigestChannelName.
  ///
  /// In en, this message translates to:
  /// **'Daily summary'**
  String get notifDigestChannelName;

  /// No description provided for @notifDigestChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'At most one summary per day when enabled in settings.'**
  String get notifDigestChannelDescription;

  /// No description provided for @notifDigestTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifDigestTitle;

  /// No description provided for @notifDigestBody.
  ///
  /// In en, this message translates to:
  /// **'{count} countdown(s) in the next 7 days.'**
  String notifDigestBody(int count);

  /// No description provided for @settingsSectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal & help'**
  String get settingsSectionLegal;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get settingsTerms;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About LuckyDate'**
  String get settingsAboutApp;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsAboutBlurb.
  ///
  /// In en, this message translates to:
  /// **'Important date reminders and local notifications. When you sign in with email, events sync to your configured cloud.'**
  String get settingsAboutBlurb;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageChinese;

  /// No description provided for @copyrightLegalese.
  ///
  /// In en, this message translates to:
  /// **'© 2026'**
  String get copyrightLegalese;

  /// No description provided for @navCountdownDay.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get navCountdownDay;

  /// No description provided for @navCountdownBook.
  ///
  /// In en, this message translates to:
  /// **'Countdown book'**
  String get navCountdownBook;

  /// No description provided for @navHistoryToday.
  ///
  /// In en, this message translates to:
  /// **'Today in history'**
  String get navHistoryToday;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @sidePanelGuest.
  ///
  /// In en, this message translates to:
  /// **'Local user'**
  String get sidePanelGuest;

  /// No description provided for @sidePanelOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get sidePanelOpenSettings;

  /// No description provided for @appBarTitleDays.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate · Countdown'**
  String get appBarTitleDays;

  /// No description provided for @appBarTitleBook.
  ///
  /// In en, this message translates to:
  /// **'Countdown book'**
  String get appBarTitleBook;

  /// No description provided for @appBarTitleHistory.
  ///
  /// In en, this message translates to:
  /// **'Today in history'**
  String get appBarTitleHistory;

  /// No description provided for @appBarTitleProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get appBarTitleProfile;

  /// No description provided for @appBarTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate'**
  String get appBarTitleDefault;

  /// No description provided for @appBarFiltered.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate · {label} only'**
  String appBarFiltered(String label);

  /// No description provided for @deleteEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event?'**
  String get deleteEventTitle;

  /// No description provided for @deleteEventBody.
  ///
  /// In en, this message translates to:
  /// **'「{title}」will be permanently deleted.'**
  String deleteEventBody(String title);

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\". You can only delete when it has no events.'**
  String deleteCategoryBody(String name);

  /// No description provided for @emptyEventsFiltered.
  ///
  /// In en, this message translates to:
  /// **'No events in this category. Tap + or change filter.'**
  String get emptyEventsFiltered;

  /// No description provided for @emptyEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Tap + to add.'**
  String get emptyEvents;

  /// No description provided for @searchEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get searchEventsHint;

  /// No description provided for @searchClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClearTooltip;

  /// No description provided for @dashboardQuickPickAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboardQuickPickAll;

  /// No description provided for @dashboardQuickPickSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a name to filter quickly. You can still type a keyword below.'**
  String get dashboardQuickPickSectionHint;

  /// No description provided for @dashboardSearchKeywordHint.
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get dashboardSearchKeywordHint;

  /// No description provided for @dashboardSearchPanelOpen.
  ///
  /// In en, this message translates to:
  /// **'Search & filter'**
  String get dashboardSearchPanelOpen;

  /// No description provided for @dashboardSearchPanelClose.
  ///
  /// In en, this message translates to:
  /// **'Hide search'**
  String get dashboardSearchPanelClose;

  /// No description provided for @dashboardSearchActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get dashboardSearchActiveBadge;

  /// No description provided for @todaySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySummaryTitle;

  /// No description provided for @todaySummaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No countdown events in the next 7 days (including today).'**
  String get todaySummaryEmpty;

  /// No description provided for @todaySummaryCreateEvent.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get todaySummaryCreateEvent;

  /// No description provided for @todaySummaryShowAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get todaySummaryShowAllCategories;

  /// No description provided for @todaySummaryOnlyCurrentCategory.
  ///
  /// In en, this message translates to:
  /// **'Match home category filter'**
  String get todaySummaryOnlyCurrentCategory;

  /// No description provided for @dashboardTodaySummaryButton.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardTodaySummaryButton;

  /// No description provided for @emptySearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching events found.'**
  String get emptySearchResults;

  /// No description provided for @onboardingHint.
  ///
  /// In en, this message translates to:
  /// **'Create an event and pick a category'**
  String get onboardingHint;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoryNameLabel;

  /// No description provided for @categoryIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon (emoji)'**
  String get categoryIconLabel;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by category'**
  String get filterByCategory;

  /// No description provided for @tooltipAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get tooltipAddCategory;

  /// No description provided for @sectionCategoryShelf.
  ///
  /// In en, this message translates to:
  /// **'Category shelf'**
  String get sectionCategoryShelf;

  /// No description provided for @sectionListFilter.
  ///
  /// In en, this message translates to:
  /// **'List & filter'**
  String get sectionListFilter;

  /// No description provided for @sectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get sectionTools;

  /// No description provided for @toolDateCalculator.
  ///
  /// In en, this message translates to:
  /// **'Date calculator'**
  String get toolDateCalculator;

  /// No description provided for @toolMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get toolMilestone;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get allEvents;

  /// No description provided for @tooltipDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get tooltipDeleteCategory;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get newEvent;

  /// No description provided for @eventCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String eventCount(int count);

  /// No description provided for @archiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive & hide'**
  String get archiveTitle;

  /// No description provided for @archivePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Archive is coming soon.'**
  String get archivePlaceholder;

  /// No description provided for @historySampleData.
  ///
  /// In en, this message translates to:
  /// **'Showing sample data (offline or no cache for this day).'**
  String get historySampleData;

  /// No description provided for @historyWikimedia.
  ///
  /// In en, this message translates to:
  /// **'Entries from Wikimedia projects.'**
  String get historyWikimedia;

  /// No description provided for @historySupabaseAi.
  ///
  /// In en, this message translates to:
  /// **'Includes Supabase AI supplement.'**
  String get historySupabaseAi;

  /// No description provided for @historyIdaily.
  ///
  /// In en, this message translates to:
  /// **'iDaily global view'**
  String get historyIdaily;

  /// No description provided for @historyExploreTagline.
  ///
  /// In en, this message translates to:
  /// **'Explore today in history.'**
  String get historyExploreTagline;

  /// No description provided for @historyHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get historyHoliday;

  /// No description provided for @historyEvents.
  ///
  /// In en, this message translates to:
  /// **'Historical events'**
  String get historyEvents;

  /// No description provided for @historyEmptySupabase.
  ///
  /// In en, this message translates to:
  /// **'No data. Pull to refresh or try again (Wikimedia API needs network). With Supabase, AI merge is attempted.'**
  String get historyEmptySupabase;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data. Pull to refresh (Wikimedia API needs network).'**
  String get historyEmpty;

  /// No description provided for @dashboardTodayFocus.
  ///
  /// In en, this message translates to:
  /// **'Today focus'**
  String get dashboardTodayFocus;

  /// No description provided for @dashboardDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String dashboardDaysLeft(int days);

  /// No description provided for @dashboardSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String dashboardSelectedCount(int count);

  /// No description provided for @dashboardCancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get dashboardCancelSelection;

  /// No description provided for @dashboardBatchMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get dashboardBatchMarkCompleted;

  /// No description provided for @dashboardBatchArchive.
  ///
  /// In en, this message translates to:
  /// **'Batch archive'**
  String get dashboardBatchArchive;

  /// No description provided for @dashboardBatchUpdateCategory.
  ///
  /// In en, this message translates to:
  /// **'Batch category'**
  String get dashboardBatchUpdateCategory;

  /// No description provided for @dashboardBatchCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Batch update category'**
  String get dashboardBatchCategoryTitle;

  /// No description provided for @dashboardBatchUpdateReminder.
  ///
  /// In en, this message translates to:
  /// **'Batch reminder'**
  String get dashboardBatchUpdateReminder;

  /// No description provided for @dashboardBatchReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Batch update reminder preset'**
  String get dashboardBatchReminderTitle;

  /// No description provided for @dashboardFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboardFilterAll;

  /// No description provided for @dashboardFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dashboardFilterActive;

  /// No description provided for @dashboardFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dashboardFilterCompleted;

  /// No description provided for @historyYearReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} Year review'**
  String historyYearReviewTitle(String year);

  /// No description provided for @historySummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get historySummaryTotal;

  /// No description provided for @historySummaryActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get historySummaryActive;

  /// No description provided for @historySummaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historySummaryCompleted;

  /// No description provided for @historySummaryArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get historySummaryArchived;

  /// No description provided for @historyCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get historyCompletionRate;

  /// No description provided for @historyCategoryRatio.
  ///
  /// In en, this message translates to:
  /// **'Category ratio'**
  String get historyCategoryRatio;

  /// No description provided for @historyArchivedEvents.
  ///
  /// In en, this message translates to:
  /// **'Archived events'**
  String get historyArchivedEvents;

  /// No description provided for @historyArchivedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String historyArchivedCount(String count);

  /// No description provided for @historyArchivedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No archived events'**
  String get historyArchivedEmpty;

  /// No description provided for @historyRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get historyRestore;

  /// No description provided for @historyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDelete;

  /// No description provided for @profileSectionCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get profileSectionCommon;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get profileFeedback;

  /// No description provided for @profileAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & security'**
  String get profileAccountSecurity;

  /// No description provided for @profileExportPng.
  ///
  /// In en, this message translates to:
  /// **'Export as image'**
  String get profileExportPng;

  /// No description provided for @toastExportOk.
  ///
  /// In en, this message translates to:
  /// **'Image generated. Save or share from the share sheet.'**
  String get toastExportOk;

  /// No description provided for @toastExportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events to export'**
  String get toastExportEmpty;

  /// No description provided for @profileSectionAboutAccount.
  ///
  /// In en, this message translates to:
  /// **'About & account'**
  String get profileSectionAboutAccount;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profilePrivacy;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Request account deletion'**
  String get profileDeleteAccountConfirmTitle;

  /// No description provided for @profileDeleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'After confirmation, your mail app will open to send a deletion request to support.'**
  String get profileDeleteAccountConfirmBody;

  /// No description provided for @profileDeleteAccountEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate account deletion request'**
  String get profileDeleteAccountEmailSubject;

  /// No description provided for @profileDeleteAccountEmailFallback.
  ///
  /// In en, this message translates to:
  /// **'Cannot open mail app. Please send an email to ruancanghui@163.com.'**
  String get profileDeleteAccountEmailFallback;

  /// No description provided for @milestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestoneTitle;

  /// No description provided for @milestoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Create one on the home tab.'**
  String get milestoneEmpty;

  /// No description provided for @milestoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your events by distance from today (nearest first).'**
  String get milestoneSubtitle;

  /// No description provided for @milestoneSection7d.
  ///
  /// In en, this message translates to:
  /// **'1–7 days'**
  String get milestoneSection7d;

  /// No description provided for @milestoneSection30d.
  ///
  /// In en, this message translates to:
  /// **'8–30 days'**
  String get milestoneSection30d;

  /// No description provided for @milestoneSectionFar.
  ///
  /// In en, this message translates to:
  /// **'Farther'**
  String get milestoneSectionFar;

  /// No description provided for @milestoneCardDesc.
  ///
  /// In en, this message translates to:
  /// **'{cat} · {dateLine} · {dist} days from today · {label}'**
  String milestoneCardDesc(
    String cat,
    String dateLine,
    String dist,
    String label,
  );

  /// No description provided for @milestoneReached.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached!'**
  String get milestoneReached;

  /// No description provided for @milestoneApproaching.
  ///
  /// In en, this message translates to:
  /// **'Milestone approaching'**
  String get milestoneApproaching;

  /// No description provided for @dateCalcTitle.
  ///
  /// In en, this message translates to:
  /// **'Date calculator'**
  String get dateCalcTitle;

  /// No description provided for @dateCalcTabInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get dateCalcTabInterval;

  /// No description provided for @dateCalcTabShift.
  ///
  /// In en, this message translates to:
  /// **'Shift date'**
  String get dateCalcTabShift;

  /// No description provided for @dateCalcStartLunarPicker.
  ///
  /// In en, this message translates to:
  /// **'Start date (lunar picker)'**
  String get dateCalcStartLunarPicker;

  /// No description provided for @dateCalcStart.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get dateCalcStart;

  /// No description provided for @dateCalcEndLunarPicker.
  ///
  /// In en, this message translates to:
  /// **'End date (lunar picker)'**
  String get dateCalcEndLunarPicker;

  /// No description provided for @dateCalcEnd.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get dateCalcEnd;

  /// No description provided for @dateCalcInclusive.
  ///
  /// In en, this message translates to:
  /// **'Include start & end'**
  String get dateCalcInclusive;

  /// No description provided for @dateCalcCompute.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get dateCalcCompute;

  /// No description provided for @dateCalcIntervalDays.
  ///
  /// In en, this message translates to:
  /// **'Interval: {n} days'**
  String dateCalcIntervalDays(int n);

  /// No description provided for @dateCalcStartLine.
  ///
  /// In en, this message translates to:
  /// **'Start: {date}'**
  String dateCalcStartLine(String date);

  /// No description provided for @dateCalcLunarLine.
  ///
  /// In en, this message translates to:
  /// **'Lunar: {lunar}'**
  String dateCalcLunarLine(String lunar);

  /// No description provided for @dateCalcEndLine.
  ///
  /// In en, this message translates to:
  /// **'End: {date}'**
  String dateCalcEndLine(String date);

  /// No description provided for @dateCalcBaseLunarPicker.
  ///
  /// In en, this message translates to:
  /// **'Base date (lunar picker)'**
  String get dateCalcBaseLunarPicker;

  /// No description provided for @dateCalcBase.
  ///
  /// In en, this message translates to:
  /// **'Base date'**
  String get dateCalcBase;

  /// No description provided for @dateCalcDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get dateCalcDaysLabel;

  /// No description provided for @dateCalcDaysHint.
  ///
  /// In en, this message translates to:
  /// **'Integer'**
  String get dateCalcDaysHint;

  /// No description provided for @dateCalcBefore.
  ///
  /// In en, this message translates to:
  /// **'N days before'**
  String get dateCalcBefore;

  /// No description provided for @dateCalcAfter.
  ///
  /// In en, this message translates to:
  /// **'N days after'**
  String get dateCalcAfter;

  /// No description provided for @dateCalcResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get dateCalcResult;

  /// No description provided for @dateCalcGregorianLine.
  ///
  /// In en, this message translates to:
  /// **'Gregorian: {date}'**
  String dateCalcGregorianLine(String date);

  /// No description provided for @loginTitleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitleSignIn;

  /// No description provided for @loginTitleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get loginTitleSignUp;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginCtaEnter.
  ///
  /// In en, this message translates to:
  /// **'Sign in & go to home'**
  String get loginCtaEnter;

  /// No description provided for @loginCtaRegister.
  ///
  /// In en, this message translates to:
  /// **'Register & go to home'**
  String get loginCtaRegister;

  /// No description provided for @loginSwitchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Sign in'**
  String get loginSwitchToSignIn;

  /// No description provided for @loginSwitchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'No account? Register'**
  String get loginSwitchToSignUp;

  /// No description provided for @loginSupabaseMissing.
  ///
  /// In en, this message translates to:
  /// **'Supabase not configured (SUPABASE_URL / SUPABASE_ANON_KEY). Demo sign-in; events won\'t sync to cloud.'**
  String get loginSupabaseMissing;

  /// No description provided for @loginDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo sign-in & go to home'**
  String get loginDemo;

  /// No description provided for @eventDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventDetailTitle;

  /// No description provided for @eventDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found or list out of sync.'**
  String get eventDetailNotFound;

  /// No description provided for @eventDetailNotifyOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get eventDetailNotifyOff;

  /// No description provided for @eventDetailNotifyOn.
  ///
  /// In en, this message translates to:
  /// **'On · {time}'**
  String eventDetailNotifyOn(String time);

  /// No description provided for @eventDetailDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete event?'**
  String get eventDetailDeleteTitle;

  /// No description provided for @eventDetailDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get eventDetailDeleteBody;

  /// No description provided for @eventDetailTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get eventDetailTargetDate;

  /// No description provided for @eventDetailLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get eventDetailLunar;

  /// No description provided for @eventDetailMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get eventDetailMode;

  /// No description provided for @eventDetailModeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get eventDetailModeCountdown;

  /// No description provided for @eventDetailModeElapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get eventDetailModeElapsed;

  /// No description provided for @eventDetailReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get eventDetailReminder;

  /// No description provided for @klingLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get klingLoading;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get legalTermsTitle;

  /// No description provided for @legalPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Full text is shown in-app; we process data on a minimal-necessary basis—see the Markdown document for details.'**
  String get legalPrivacyBody;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Full text is shown in-app; by using the app you agree to the complete terms.'**
  String get legalTermsBody;

  /// No description provided for @legalMdLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the document. Please try again or restart the app.'**
  String get legalMdLoadError;

  /// No description provided for @legalConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to 吉辰万年历'**
  String get legalConsentTitle;

  /// No description provided for @legalConsentMessage.
  ///
  /// In en, this message translates to:
  /// **'To continue, please read and agree to the Terms of Service and Privacy Policy. Use the links below to read the full text; tap agree to enter the app.'**
  String get legalConsentMessage;

  /// No description provided for @legalConsentAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree and continue'**
  String get legalConsentAgree;

  /// No description provided for @legalConsentDisagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree and exit'**
  String get legalConsentDisagree;

  /// No description provided for @legalConsentViewTerms.
  ///
  /// In en, this message translates to:
  /// **'View terms of service'**
  String get legalConsentViewTerms;

  /// No description provided for @legalConsentViewPrivacy.
  ///
  /// In en, this message translates to:
  /// **'View privacy policy'**
  String get legalConsentViewPrivacy;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & security'**
  String get accountSecurityTitle;

  /// No description provided for @accountLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to edit nickname and view account info.'**
  String get accountLoginPrompt;

  /// No description provided for @accountGoLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountGoLogin;

  /// No description provided for @accountUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get accountUserId;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmail;

  /// No description provided for @accountLoginMethod.
  ///
  /// In en, this message translates to:
  /// **'Sign-in method'**
  String get accountLoginMethod;

  /// No description provided for @accountLoginMethodSupabase.
  ///
  /// In en, this message translates to:
  /// **'Supabase email'**
  String get accountLoginMethodSupabase;

  /// No description provided for @accountNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get accountNickname;

  /// No description provided for @accountNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Stored only in local profile'**
  String get accountNicknameHint;

  /// No description provided for @toastNicknameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nickname cannot be empty'**
  String get toastNicknameEmpty;

  /// No description provided for @toastNicknameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Nickname max 32 characters'**
  String get toastNicknameTooLong;

  /// No description provided for @toastSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get toastSaved;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose a type and describe the issue. Content is saved on this device only.'**
  String get feedbackIntro;

  /// No description provided for @feedbackTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get feedbackTypeLabel;

  /// No description provided for @feedbackContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get feedbackContentLabel;

  /// No description provided for @feedbackContentHint.
  ///
  /// In en, this message translates to:
  /// **'Steps, expected vs actual behavior'**
  String get feedbackContentHint;

  /// No description provided for @feedbackTypeFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature request'**
  String get feedbackTypeFeature;

  /// No description provided for @feedbackTypeBug.
  ///
  /// In en, this message translates to:
  /// **'Bug report'**
  String get feedbackTypeBug;

  /// No description provided for @feedbackTypeAccount.
  ///
  /// In en, this message translates to:
  /// **'Account & sync'**
  String get feedbackTypeAccount;

  /// No description provided for @feedbackTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get feedbackTypeOther;

  /// No description provided for @toastFeedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter feedback'**
  String get toastFeedbackEmpty;

  /// No description provided for @toastFeedbackTooLong.
  ///
  /// In en, this message translates to:
  /// **'Content exceeds {max} characters'**
  String toastFeedbackTooLong(int max);

  /// No description provided for @toastFeedbackSavedLocal.
  ///
  /// In en, this message translates to:
  /// **'Saved on device'**
  String get toastFeedbackSavedLocal;

  /// No description provided for @permNotifyMasterOffTitle.
  ///
  /// In en, this message translates to:
  /// **'In-app notifications are off'**
  String get permNotifyMasterOffTitle;

  /// No description provided for @permNotifyMasterOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on \"Notifications master switch\" in Settings first.'**
  String get permNotifyMasterOffBody;

  /// No description provided for @permGoEnable.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permGoEnable;

  /// No description provided for @permNeedSystemNotifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permission needed'**
  String get permNeedSystemNotifyTitle;

  /// No description provided for @permNeedSystemNotifyBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Enable in Settings → LuckyDate → Notifications.'**
  String get permNeedSystemNotifyBodyIos;

  /// No description provided for @permNeedSystemNotifyBodyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required for reminders.'**
  String get permNeedSystemNotifyBodyGeneric;

  /// No description provided for @permOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get permOpenSystemSettings;

  /// No description provided for @permNeedCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar access needed'**
  String get permNeedCalendarTitle;

  /// No description provided for @permNeedCalendarBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Calendar access denied. Enable in Settings → LuckyDate.'**
  String get permNeedCalendarBodyIos;

  /// No description provided for @permNeedCalendarBodyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Calendar access is needed to write events.'**
  String get permNeedCalendarBodyGeneric;

  /// No description provided for @permNeedRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders access needed'**
  String get permNeedRemindersTitle;

  /// No description provided for @permNeedRemindersBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Reminders denied. Enable in Settings → LuckyDate.'**
  String get permNeedRemindersBodyIos;

  /// No description provided for @permNeedRemindersBodyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Reminders access is needed to sync.'**
  String get permNeedRemindersBodyGeneric;

  /// No description provided for @permNotifyMasterOffSaveBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on the in-app notification switch to schedule local reminders.\n\nYou can save the event and enable notifications later in Settings.'**
  String get permNotifyMasterOffSaveBody;

  /// No description provided for @permSaveWithoutReminder.
  ///
  /// In en, this message translates to:
  /// **'Save without reminder'**
  String get permSaveWithoutReminder;

  /// No description provided for @permNeedNotifyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permission needed'**
  String get permNeedNotifyDetailTitle;

  /// No description provided for @permNeedNotifyDetailBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled. Enable in Settings → LuckyDate → Notifications.'**
  String get permNeedNotifyDetailBodyIos;

  /// No description provided for @permNeedNotifyDetailBodyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Grant notification permission in system settings for local reminders.'**
  String get permNeedNotifyDetailBodyGeneric;

  /// No description provided for @toastEnterEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter event title'**
  String get toastEnterEventTitle;

  /// No description provided for @toastTitleMax.
  ///
  /// In en, this message translates to:
  /// **'Title max {max} characters'**
  String toastTitleMax(int max);

  /// No description provided for @toastSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed. Check network or sign-in.'**
  String get toastSaveFailed;

  /// No description provided for @toastSavedReminderPending.
  ///
  /// In en, this message translates to:
  /// **'Saved. Reminder inactive — enable in Settings or OS permissions, then edit this event.'**
  String get toastSavedReminderPending;

  /// No description provided for @toastAddedCalReminders.
  ///
  /// In en, this message translates to:
  /// **'Added to Calendar & Reminders'**
  String get toastAddedCalReminders;

  /// No description provided for @toastAddedCalNoRemindersPerm.
  ///
  /// In en, this message translates to:
  /// **'Added to Calendar; Reminders skipped (no permission)'**
  String get toastAddedCalNoRemindersPerm;

  /// No description provided for @toastAddedCalRemindersFail.
  ///
  /// In en, this message translates to:
  /// **'Added to Calendar; Reminders failed, try again'**
  String get toastAddedCalRemindersFail;

  /// No description provided for @toastAddedCal.
  ///
  /// In en, this message translates to:
  /// **'Added to Calendar'**
  String get toastAddedCal;

  /// No description provided for @toastCalNoPerm.
  ///
  /// In en, this message translates to:
  /// **'Not written to Calendar — no permission. Enable in Settings.'**
  String get toastCalNoPerm;

  /// No description provided for @toastCalWriteFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to write Calendar. Check permission or try again.'**
  String get toastCalWriteFail;

  /// No description provided for @repeatSingle.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get repeatSingle;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get repeatYearly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthly;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get repeatWeekly;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDaily;

  /// No description provided for @remindSameDay.
  ///
  /// In en, this message translates to:
  /// **'Same day'**
  String get remindSameDay;

  /// No description provided for @remind1DayBefore.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get remind1DayBefore;

  /// No description provided for @remind3DaysBefore.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get remind3DaysBefore;

  /// No description provided for @remind7DaysBefore.
  ///
  /// In en, this message translates to:
  /// **'7 days before'**
  String get remind7DaysBefore;

  /// No description provided for @remindNDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{n} days before'**
  String remindNDaysBefore(Object n);

  /// No description provided for @eventFormReminderRules.
  ///
  /// In en, this message translates to:
  /// **'Reminder rules'**
  String get eventFormReminderRules;

  /// No description provided for @eventFormRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get eventFormRepeat;

  /// No description provided for @eventFormTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eventFormTime;

  /// No description provided for @eventFormAdvance.
  ///
  /// In en, this message translates to:
  /// **'Advance notice'**
  String get eventFormAdvance;

  /// No description provided for @dropdownSameDay.
  ///
  /// In en, this message translates to:
  /// **'Same day'**
  String get dropdownSameDay;

  /// No description provided for @dropdown1DayBefore.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get dropdown1DayBefore;

  /// No description provided for @dropdown3DaysBefore.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get dropdown3DaysBefore;

  /// No description provided for @dropdown7DaysBefore.
  ///
  /// In en, this message translates to:
  /// **'7 days before'**
  String get dropdown7DaysBefore;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @eventFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventFormTitleEdit;

  /// No description provided for @eventFormTitleCreate.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get eventFormTitleCreate;

  /// No description provided for @eventFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get eventFormSave;

  /// No description provided for @eventFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventFormNameLabel;

  /// No description provided for @eventFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name this important day'**
  String get eventFormNameHint;

  /// No description provided for @eventFormDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventFormDate;

  /// No description provided for @eventFormLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get eventFormLunar;

  /// No description provided for @eventFormCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get eventFormCategory;

  /// No description provided for @eventFormColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get eventFormColorLabel;

  /// No description provided for @eventFormColorReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get eventFormColorReset;

  /// No description provided for @eventFormTimer.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get eventFormTimer;

  /// No description provided for @eventFormCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get eventFormCountdown;

  /// No description provided for @eventFormElapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get eventFormElapsed;

  /// No description provided for @eventFormReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get eventFormReminder;

  /// No description provided for @eventFormReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Checks in-app notification switch and OS permission when enabled.'**
  String get eventFormReminderHint;

  /// No description provided for @eventFormReminderConfigure.
  ///
  /// In en, this message translates to:
  /// **'Tap to set repeat, time, and advance notice.'**
  String get eventFormReminderConfigure;

  /// No description provided for @eventFormCalendarAfterSave.
  ///
  /// In en, this message translates to:
  /// **'Add to system calendar after save'**
  String get eventFormCalendarAfterSave;

  /// No description provided for @eventFormCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'Requests calendar permission; writes to Calendar on save (can work with in-app reminders).'**
  String get eventFormCalendarHint;

  /// No description provided for @eventFormRemindersIos.
  ///
  /// In en, this message translates to:
  /// **'Also write to Reminders'**
  String get eventFormRemindersIos;

  /// No description provided for @eventFormRemindersIosHint.
  ///
  /// In en, this message translates to:
  /// **'Requires Reminders permission; separate from in-app notifications.'**
  String get eventFormRemindersIosHint;

  /// No description provided for @eventFormReminderDetail.
  ///
  /// In en, this message translates to:
  /// **'Reminder detail'**
  String get eventFormReminderDetail;

  /// No description provided for @eventFormReminderType.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get eventFormReminderType;

  /// No description provided for @eventFormReminderSingle.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get eventFormReminderSingle;

  /// No description provided for @eventFormReminderDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get eventFormReminderDaily;

  /// No description provided for @eventFormReminderWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get eventFormReminderWeekly;

  /// No description provided for @eventFormReminderMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get eventFormReminderMonthly;

  /// No description provided for @eventFormReminderYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get eventFormReminderYearly;

  /// No description provided for @eventFormHardDeadline.
  ///
  /// In en, this message translates to:
  /// **'Hard deadline'**
  String get eventFormHardDeadline;

  /// No description provided for @eventFormHardDeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'Emphasize in the list; optional 7/3/1 reminder rhythm for countdown (once).'**
  String get eventFormHardDeadlineHint;

  /// No description provided for @eventFormApplyRhythm731.
  ///
  /// In en, this message translates to:
  /// **'Apply 7 / 3 / 1 day rhythm'**
  String get eventFormApplyRhythm731;

  /// No description provided for @eventFormRhythm731Applied.
  ///
  /// In en, this message translates to:
  /// **'Rhythm will apply after you save'**
  String get eventFormRhythm731Applied;

  /// No description provided for @eventFormRhythm731Requires.
  ///
  /// In en, this message translates to:
  /// **'Requires countdown, “Once” repeat, and reminder on'**
  String get eventFormRhythm731Requires;

  /// No description provided for @eventDetailShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get eventDetailShare;

  /// No description provided for @eventShareFilename.
  ///
  /// In en, this message translates to:
  /// **'jichen-event.png'**
  String get eventShareFilename;

  /// No description provided for @eventShareIcsFilename.
  ///
  /// In en, this message translates to:
  /// **'jichen-event.ics'**
  String get eventShareIcsFilename;

  /// No description provided for @eventShareText.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate · event'**
  String get eventShareText;

  /// No description provided for @eventShareWebFallback.
  ///
  /// In en, this message translates to:
  /// **'Sharing as text on web (image export is mobile/desktop).'**
  String get eventShareWebFallback;

  /// No description provided for @networkErrCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get networkErrCancelled;

  /// No description provided for @networkErrConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get networkErrConnectionTimeout;

  /// No description provided for @networkErrSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Send timed out'**
  String get networkErrSendTimeout;

  /// No description provided for @networkErrReceiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Response timed out'**
  String get networkErrReceiveTimeout;

  /// No description provided for @networkErr400.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get networkErr400;

  /// No description provided for @networkErr401.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get networkErr401;

  /// No description provided for @networkErr403.
  ///
  /// In en, this message translates to:
  /// **'Forbidden'**
  String get networkErr403;

  /// No description provided for @networkErr404.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach server'**
  String get networkErr404;

  /// No description provided for @networkErr405.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get networkErr405;

  /// No description provided for @networkErr500.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get networkErr500;

  /// No description provided for @networkErr502.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get networkErr502;

  /// No description provided for @networkErr503.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get networkErr503;

  /// No description provided for @networkErr505.
  ///
  /// In en, this message translates to:
  /// **'HTTP version not supported'**
  String get networkErr505;

  /// No description provided for @networkErrUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get networkErrUnknown;

  /// No description provided for @lunarPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick lunar date (approx. 1901–2049)'**
  String get lunarPickerTitle;

  /// No description provided for @lunarLabelYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get lunarLabelYear;

  /// No description provided for @lunarLabelMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get lunarLabelMonth;

  /// No description provided for @lunarLabelDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get lunarLabelDay;

  /// No description provided for @lunarInvalidDay.
  ///
  /// In en, this message translates to:
  /// **'Invalid lunar date: {error}'**
  String lunarInvalidDay(String error);

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Event reminders'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate'**
  String get notifChannelDescription;

  /// No description provided for @notifBodyLine.
  ///
  /// In en, this message translates to:
  /// **'[{app}] {title} ({mode}): {label}'**
  String notifBodyLine(String app, String title, String mode, String label);

  /// No description provided for @calExportNotesLine.
  ///
  /// In en, this message translates to:
  /// **'{app} · {mode} · {cat}'**
  String calExportNotesLine(String app, String mode, String cat);

  /// No description provided for @exportErrLayoutIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Could not render image (layout not ready). Try again.'**
  String get exportErrLayoutIncomplete;

  /// No description provided for @exportErrEncodeFail.
  ///
  /// In en, this message translates to:
  /// **'Image encoding failed'**
  String get exportErrEncodeFail;

  /// No description provided for @exportShareFilename.
  ///
  /// In en, this message translates to:
  /// **'jichen-events.png'**
  String get exportShareFilename;

  /// No description provided for @exportShareText.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate · event list export'**
  String get exportShareText;

  /// No description provided for @exportFailWithError.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailWithError(String error);

  /// No description provided for @exportListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Event list · image export'**
  String get exportListSubtitle;

  /// No description provided for @exportTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Exported at'**
  String get exportTimeLabel;

  /// No description provided for @exportMetaTotalSorted.
  ///
  /// In en, this message translates to:
  /// **'{count} events · sorted nearest to today first'**
  String exportMetaTotalSorted(int count);

  /// No description provided for @exportSolarLine.
  ///
  /// In en, this message translates to:
  /// **'Gregorian: {line}'**
  String exportSolarLine(String line);

  /// No description provided for @exportLunarLine.
  ///
  /// In en, this message translates to:
  /// **'Lunar: {line}'**
  String exportLunarLine(String line);

  /// No description provided for @exportTypeCategoryLine.
  ///
  /// In en, this message translates to:
  /// **'Type: {type} · Category: {cat}'**
  String exportTypeCategoryLine(String type, String cat);

  /// No description provided for @exportTypeCountdownShort.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get exportTypeCountdownShort;

  /// No description provided for @exportTypeCountupShort.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get exportTypeCountupShort;

  /// No description provided for @exportTruncatedNote.
  ///
  /// In en, this message translates to:
  /// **'{total} events total · only the first {limit} are shown'**
  String exportTruncatedNote(int total, int limit);

  /// No description provided for @exportFooterTagline.
  ///
  /// In en, this message translates to:
  /// **'LuckyDate · remember every day that matters'**
  String get exportFooterTagline;

  /// No description provided for @exportSummaryCdToday.
  ///
  /// In en, this message translates to:
  /// **'Countdown · Today'**
  String get exportSummaryCdToday;

  /// No description provided for @exportSummaryCdPast.
  ///
  /// In en, this message translates to:
  /// **'Countdown · target date passed'**
  String get exportSummaryCdPast;

  /// No description provided for @exportSummaryCdRemain.
  ///
  /// In en, this message translates to:
  /// **'Countdown · {n} days left'**
  String exportSummaryCdRemain(int n);

  /// No description provided for @exportSummaryCuFirst.
  ///
  /// In en, this message translates to:
  /// **'Elapsed · start day (day 1)'**
  String get exportSummaryCuFirst;

  /// No description provided for @exportSummaryCuNth.
  ///
  /// In en, this message translates to:
  /// **'Elapsed · day {n}'**
  String exportSummaryCuNth(int n);

  /// No description provided for @exportHeroToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get exportHeroToday;

  /// No description provided for @exportHeroFirstDay.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get exportHeroFirstDay;

  /// No description provided for @exportHeroUnitDay.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get exportHeroUnitDay;

  /// No description provided for @exportCountupPrefix.
  ///
  /// In en, this message translates to:
  /// **'Day '**
  String get exportCountupPrefix;

  /// No description provided for @exportCountupSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get exportCountupSuffix;

  /// No description provided for @categoryMemorial.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get categoryMemorial;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get categoryLife;

  /// No description provided for @builtinEventNextSaturday.
  ///
  /// In en, this message translates to:
  /// **'Until Saturday'**
  String get builtinEventNextSaturday;

  /// No description provided for @builtinEventYearEnd.
  ///
  /// In en, this message translates to:
  /// **'Until year end'**
  String get builtinEventYearEnd;

  /// No description provided for @builtinEventAppleFounded.
  ///
  /// In en, this message translates to:
  /// **'Apple founded'**
  String get builtinEventAppleFounded;

  /// No description provided for @dayLabelToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dayLabelToday;

  /// No description provided for @dayLabelCountupFirst.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get dayLabelCountupFirst;

  /// No description provided for @repoErrNotLoggedInList.
  ///
  /// In en, this message translates to:
  /// **'Not signed in or session expired. Please sign in again.'**
  String get repoErrNotLoggedInList;

  /// No description provided for @repoErrNotLoggedInWrite.
  ///
  /// In en, this message translates to:
  /// **'Not signed in or session expired. Cannot sync to cloud.'**
  String get repoErrNotLoggedInWrite;

  /// No description provided for @repoErrNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in or session expired.'**
  String get repoErrNotLoggedIn;

  /// No description provided for @repoErrLocalDupId.
  ///
  /// In en, this message translates to:
  /// **'Local data error: duplicate ID.'**
  String get repoErrLocalDupId;

  /// No description provided for @repoErrLocalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event not found locally.'**
  String get repoErrLocalNotFound;

  /// No description provided for @repoErrDbSchema.
  ///
  /// In en, this message translates to:
  /// **'Database schema mismatch (e.g. missing reminder_json). Run migrations and retry.'**
  String get repoErrDbSchema;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
