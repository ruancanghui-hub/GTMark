import 'package:flutter/material.dart';

import '../core/hydration/models.dart';
import 'app_locale.dart';
import 'insight_articles.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final AppLocale locale;

  bool get isZh => locale == AppLocale.zh;

  static const supportedLocales = [
    Locale('zh'),
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // App
  String get appTitle => isZh ? '轻补水' : 'Qing Water';
  String get appTagline => isZh ? '温柔补水' : 'Hydrate gently';
  String get splashLoading => isZh ? '加载中…' : 'Loading…';

  // Bottom nav
  String get navToday => isZh ? '今日' : 'Today';
  String get navHistory => isZh ? '历史' : 'History';
  String get navAdd => isZh ? '添加' : 'Add';
  String get navInsights => isZh ? '资讯' : 'Insights';
  String get navMe => isZh ? '我的' : 'Me';

  // Home
  String get goal => isZh ? '目标' : 'Goal';
  String get reminder => isZh ? '提醒' : 'Reminder';
  String get dailyGoal => isZh ? '每日目标' : 'Daily Goal';
  String get hydrationDashboard => isZh ? '补水看板' : 'Hydration dashboard';
  String get quickAdd => isZh ? '快捷添加' : 'Quick add';
  String get drinkButton => isZh ? '+ 喝水' : '+ Drink';
  String get drinkAction => isZh ? '喝水' : 'DRINK';
  String get confirmDrink => isZh ? '确认喝水' : 'Confirm drink';
  String get todaysDrinks => isZh ? '今日饮水' : "Today's drinks";
  String get noRecords => isZh ? '暂无记录' : 'No records';
  String recentCount(int n) => isZh ? '最近 $n 条' : '$n recent';
  String get emptyTodayHint => isZh ? '点击 + 添加今天第一杯水' : 'Tap + to add your first cup today.';
  String recordLogged(double oz) =>
      isZh ? '已记录 ${oz.toStringAsFixed(1)} oz' : 'Logged ${oz.toStringAsFixed(1)} oz';
  String outOfGoal(String drank, String goal) =>
      isZh ? '$drank / $goal oz' : '$drank out of ${goal}oz';

  // History
  String get tabDay => isZh ? '日' : 'Day';
  String get tabWeek => isZh ? '周' : 'Week';
  String get tabMonth => isZh ? '月' : 'Month';
  String get dailyAverage => isZh ? '日均' : 'Daily Average';
  String get total => isZh ? '总计' : 'Total';
  String get historyTitle => isZh ? '饮水历史' : 'Hydration history';
  String get noHistoryRecords => isZh ? '暂无历史记录' : 'No history records yet';
  String get editDrink => isZh ? '编辑记录' : 'Edit drink';
  String get delete => isZh ? '删除' : 'Delete';
  String get save => isZh ? '保存' : 'Save';
  String get drinkUpdated => isZh ? '记录已更新' : 'Drink updated';
  String get drinkDeleted => isZh ? '记录已删除' : 'Drink deleted';
  String get recordNotFound => isZh ? '记录不存在' : 'Record not found';
  String get adjustTimeMinus => isZh ? '-15 分钟' : '-15 min';
  String get adjustTimePlus => isZh ? '+15 分钟' : '+15 min';
  String get gotIt => isZh ? '知道了' : 'Got it';
  String get amount => isZh ? '容量' : 'Amount';
  String get time => isZh ? '时间' : 'Time';
  String get noDrinksToday => isZh ? '今天还没有饮水记录。' : 'No drinks logged yet today.';
  String historyTotal(String total) => isZh ? '总计 $total' : 'Total $total';

  // Drink select
  String get addDrink => isZh ? '添加饮品' : 'Add drink';
  String get sectionWater => isZh ? '水' : 'WATER';
  String get sectionOther => isZh ? '其他' : 'OTHER';
  String get tuneAmount => isZh ? '调节容量' : 'Tune amount';
  String get chooseYourSip => isZh ? '选择饮品' : 'Choose your sip';
  String get buildYourCup => isZh ? '打造你的杯子' : 'Build your cup';
  String get pickDrinkHint =>
      isZh ? '选择饮品，然后滑动调节精确容量。' : 'Pick a drink, then slide to tune the exact amount.';
  String choicesCount(int n) => isZh ? '$n 种选择' : '$n choices';

  // Drinks
  String drinkLabel(DrinkType type) {
    switch (type) {
      case DrinkType.water:
        return isZh ? '水' : 'Water';
      case DrinkType.tea:
        return isZh ? '茶' : 'Tea';
      case DrinkType.coffee:
        return isZh ? '咖啡' : 'Coffee';
      case DrinkType.juice:
        return isZh ? '果汁' : 'Juice';
      case DrinkType.custom:
        return isZh ? '自定义' : 'Custom drink';
      case DrinkType.milk:
        return isZh ? '牛奶' : 'Milk';
      case DrinkType.beer:
        return isZh ? '啤酒' : 'Beer';
      case DrinkType.coldDrink:
        return isZh ? '冷饮' : 'Cold drink';
      case DrinkType.orangeJuice:
        return isZh ? '橙汁' : 'Orange juice';
    }
  }

  String drinkPresetLabel(String key) {
    switch (key) {
      case 'smallGlass':
        return isZh ? '小杯' : 'Small Glass';
      case 'standardGlass':
        return isZh ? '标准杯' : 'Standard Glass';
      case 'largeGlass':
        return isZh ? '大杯' : 'Large Glass';
      case 'tea':
        return drinkLabel(DrinkType.tea);
      case 'coffee':
        return drinkLabel(DrinkType.coffee);
      case 'milk':
        return drinkLabel(DrinkType.milk);
      case 'orangeJuice':
        return drinkLabel(DrinkType.orangeJuice);
      case 'beer':
        return drinkLabel(DrinkType.beer);
      case 'coldDrink':
        return drinkLabel(DrinkType.coldDrink);
      default:
        return key;
    }
  }

  // Onboarding
  String get yourDailyGoalIs => isZh ? '你的每日目标是' : 'Your daily goal is';
  String get calculate => isZh ? '计算' : 'Calculate';
  String get startHydrating => isZh ? '开始补水' : 'Start hydrating';
  String get female => isZh ? '女性' : 'Female';
  String get male => isZh ? '男性' : 'Male';
  String get sedentary => isZh ? '久坐' : 'Sedentary';
  String get exercises => isZh ? '运动' : 'Exercises';
  String get athlete => isZh ? '高强度' : 'Athlete';
  String climateLabel(Climate c) {
    switch (c) {
      case Climate.cold:
        return isZh ? '寒冷' : 'Cold';
      case Climate.mild:
        return isZh ? '温和' : 'Mild';
      case Climate.hot:
        return isZh ? '炎热' : 'Hot';
    }
  }

  String genderLabel(Gender g) => g == Gender.female ? female : male;

  String activityLabel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.low:
        return sedentary;
      case ActivityLevel.medium:
        return exercises;
      case ActivityLevel.high:
        return athlete;
    }
  }

  // Me
  String get me => isZh ? '我的' : 'Me';
  String get feedback => isZh ? '反馈' : 'Feedback';
  String get unit => isZh ? '单位' : 'Unit';
  String get personalDetails => isZh ? '个人资料' : 'Personal Details';
  String get recalculateGoal => isZh ? '重新计算目标' : 'Recalculate Goal';
  String get language => isZh ? '语言' : 'Language';
  String get removeAds => isZh ? '去广告' : 'Remove Ads';
  String get removeAdsNote => isZh ? '竞品有，本版跳过' : 'Competitor feature, skipped in this build';
  String get sendFeedback => isZh ? '发送反馈' : 'Send feedback';
  String get feedbackHint => isZh ? '告诉我们你的想法…' : 'Tell us what you think…';
  String get feedbackEmpty => isZh ? '请先输入反馈内容' : 'Please enter feedback first';
  String get feedbackSaved => isZh ? '反馈已保存' : 'Feedback saved';
  String get dailyGoalUpdated => isZh ? '每日目标已更新' : 'Daily goal updated';
  String get profileUpdated => isZh ? '资料已更新' : 'Profile updated';
  String get goalRecalculated => isZh ? '目标已重新计算' : 'Goal recalculated';
  String get editDailyGoal => isZh ? '编辑每日目标' : 'Edit daily goal';
  String get editProfile => isZh ? '编辑个人资料' : 'Edit profile';
  String get weight => isZh ? '体重' : 'Weight';
  String get gender => isZh ? '性别' : 'Gender';
  String get activity => isZh ? '活动量' : 'Activity';
  String get climate => isZh ? '气候' : 'Climate';
  String get saveGoal => isZh ? '保存目标' : 'Save goal';
  String get saveProfile => isZh ? '保存资料' : 'Save profile';
  String goalPreview(String volume) => isZh ? '目标 $volume' : 'Goal $volume';
  String weightLbs(int lbs) => isZh ? '$lbs 磅' : '$lbs lbs';

  // Reminders
  String get reminders => isZh ? '提醒' : 'Reminders';
  String get enableReminders => isZh ? '开启提醒' : 'Enable reminders';
  String get wakeUpWater => isZh ? '起床喝水' : 'Wake-up water';
  String get beforeMeals => isZh ? '餐前' : 'Before meals';
  String get afterMeals => isZh ? '餐后' : 'After meals';
  String get bedtime => isZh ? '睡前' : 'Bedtime';
  String get muteAtNight => isZh ? '夜间静音' : 'Mute at night';
  String muteUntil(String time) => isZh ? '静音至 $time' : 'Muted until $time';
  String get muteOff => isZh ? '已关闭' : 'Off';
  String get whenEndDay => isZh ? '你通常几点结束一天？' : 'When do you usually end a day?';
  String get reminderNote =>
      isZh ? '使用标准本地通知，禁用全屏常亮提醒。' : 'Uses standard local notifications only — no full-screen wake alerts.';
  String get enableNotifications => isZh ? '开启通知权限' : 'Enable notifications';
  String get notificationsEnabled => isZh ? '通知已开启' : 'Notifications enabled';
  String get notificationsDisabled => isZh ? '通知已关闭' : 'Notifications disabled';
  String get permissionNeeded => isZh ? '需要通知权限' : 'Notification permission needed';
  String reminderStatus(bool enabled, bool permitted) {
    if (!permitted) return permissionNeeded;
    return enabled ? notificationsEnabled : notificationsDisabled;
  }

  String get systemNotificationPermission =>
      isZh ? '系统通知权限' : 'System notification permission';
  String get enableSystemNotificationsOnce => isZh
      ? '请开启系统通知，提醒才能在本机按时触发。'
      : 'Enable system notifications once so reminder times can actually fire on this device.';
  String get remindersRebuildNote => isZh
      ? '修改设置后会重新安排本地通知。'
      : 'Local notifications are rebuilt whenever you change these settings.';
  String get editTime => isZh ? '编辑时间' : 'Edit time';

  String dailyRemindersStatus(int count, bool permitted, bool enabled) {
    if (!permitted && enabled) return permissionNeeded;
    if (count == 0) return isZh ? '暂无每日提醒' : 'No daily reminders active';
    if (count == 1) return isZh ? '1 条每日提醒已就绪' : '1 daily reminder ready';
    return isZh ? '$count 条每日提醒已就绪' : '$count daily reminders ready';
  }
  String notificationTitle(String slot) {
    switch (slot) {
      case 'wakeUp':
        return isZh ? '该喝起床水了' : "It's time to drink wake-up water";
      case 'beforeMeal':
        return isZh ? '餐前喝点水' : 'Drink water before meals';
      case 'afterMeal':
        return isZh ? '餐后喝点水' : 'Drink water after meals';
      case 'bedtime':
        return isZh ? '睡前喝点水' : 'Drink water before bed';
      default:
        return isZh ? '该喝水了' : 'Time to drink water';
    }
  }

  // Insights
  String get insights => isZh ? '资讯' : 'INSIGHTS';
  String get waterDrinking => isZh ? '饮水知识' : 'Water Drinking';
  String get otherDrinks => isZh ? '其他饮品' : 'Other drinks';
  String get beautySkincare => isZh ? '美容护肤' : 'Beauty & Skincare';
  String get selfCare => isZh ? '自我关爱' : 'Self-care';

  String insightSectionTitle(InsightSection section) {
    switch (section) {
      case InsightSection.waterDrinking:
        return waterDrinking;
      case InsightSection.beautySkincare:
        return beautySkincare;
      case InsightSection.selfCare:
        return selfCare;
    }
  }

  String insightArticleTitle(InsightArticle article) {
    switch (article) {
      case InsightArticle.avoidMistakes:
        return isZh ? '避免这些饮水误区' : 'Avoid These Water Drinking Mistakes';
      case InsightArticle.bestTimes:
        return isZh ? '最佳饮水时间' : 'Best Times to Drink Water';
      case InsightArticle.replaceBeverages:
        return isZh ? '用水替代其他饮品' : 'Replace Beverages with Water';
      case InsightArticle.skinBenefits:
        return isZh ? '饮水对皮肤的益处' : 'Benefits of Drinking Water for Skin';
      case InsightArticle.wrinkleSchedule:
        return isZh ? '抗皱饮水时间表' : 'Drinking Schedule for Wrinkle-Free Skin';
      case InsightArticle.glowingSkin:
        return isZh ? '焕亮肌肤秘诀' : 'Miracle Glowing Skin';
      case InsightArticle.sleepHydration:
        return isZh ? '睡眠与补水' : 'Sleep and Hydration';
      case InsightArticle.alcoholBalance:
        return isZh ? '酒精与水平衡' : 'Alcohol vs Water Balance';
      case InsightArticle.dailyRitual:
        return isZh ? '每日补水仪式' : 'Daily Hydration Ritual';
    }
  }

  String insightArticleBody(InsightArticle article) {
    switch (article) {
      case InsightArticle.avoidMistakes:
        return isZh
            ? '不要把一天的饮水都留到晚上。白天均匀小口喝，运动、炎热、饮酒或吃咸后适当加量。'
            : 'Do not save all your water for late evening. Sip steadily through the day, and add more after exercise, heat, alcohol, or salty meals.';
      case InsightArticle.bestTimes:
        return isZh
            ? '起床后先喝水，餐前适量饮用，工作时手边放一瓶水；若夜间起夜影响睡眠，睡前可适当减少。'
            : 'Start with water after waking, drink before meals, keep a bottle nearby during work, and slow down close to bedtime if nighttime bathroom trips interrupt sleep.';
      case InsightArticle.replaceBeverages:
        return isZh
            ? '先从每天少喝一种含糖饮料、多喝一杯水开始。茶、咖啡、果汁照常记录，补水数据才真实。'
            : 'Swap one sweet drink for water each day first. Keep tea, coffee, and juice in your log so your hydration picture stays honest.';
      case InsightArticle.skinBenefits:
        return isZh
            ? '充足饮水有助于皮肤舒适与弹性，配合睡眠、防晒和规律作息效果更好，但不是万能药。'
            : 'Hydration supports skin comfort and elasticity, especially when paired with sleep, sunscreen, and a steady routine. It is helpful, not magic.';
      case InsightArticle.wrinkleSchedule:
        return isZh
            ? '均衡分配比一次猛喝更好：晨起补水、午间补充、晚间放缓，让皮肤水分更稳定。'
            : 'A balanced day works better than big spikes: morning water, mid-day refills, and a lighter evening pace keep hydration steadier.';
      case InsightArticle.glowingSkin:
        return isZh
            ? '健康光泽来自坚持：足量饮水、规律饮食、充足睡眠和皮肤防护。记录一周，观察自己的规律。'
            : 'Healthy glow usually comes from consistency: enough water, regular meals, sleep, and skin protection. Track your routine for a week and look for patterns.';
      case InsightArticle.sleepHydration:
        return isZh
            ? '白天多喝、睡前减量。若晨起口渴，可回顾咖啡因、室温和晚间咸食。'
            : 'Hydrate earlier in the day and taper before bed. If you wake up thirsty, review caffeine, room temperature, and late salty snacks.';
      case InsightArticle.alcoholBalance:
        return isZh
            ? '酒精可能增加体液流失。饮酒间隙多喝水，并同时记录，日总量才反映真实平衡。'
            : 'Alcohol can increase fluid loss. Add water between drinks and log both so your daily total reflects the real balance.';
      case InsightArticle.dailyRitual:
        return isZh
            ? '把喝水融入已有习惯：起床、开始工作、午餐、下午休息、晚间放松。'
            : 'Pair water with habits you already do: wake up, first work session, lunch, afternoon reset, and evening wind-down.';
    }
  }

  String insightDefaultBody() => isZh
      ? '小而稳的补水习惯，胜过一天内的剧烈改变。坚持记录，作息变化时再调整目标。'
      : 'Small, steady hydration habits beat dramatic one-day changes. Keep logging and adjust your goal when your routine changes.';

  // Misc
  String get ok => isZh ? '确定' : 'OK';
  String get cancel => isZh ? '取消' : 'Cancel';

  String get localeDisplayName => locale.displayName;

  String otherLocaleName(AppLocale other) => other.displayName;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final appLocale = AppLocale.fromFlutterLocale(locale) ?? AppLocale.zh;
    return AppLocalizations(appLocale);
  }

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => false;
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
