import '../../core/hydration/models.dart';

class QwAssets {
  const QwAssets._();

  static const navToday = 'assets/qw_crystal/generated_icons/nav_today.png';
  static const navHistory = 'assets/qw_crystal/generated_icons/nav_history.png';
  static const navAdd = 'assets/qw_crystal/generated_icons/nav_add.png';
  static const navInsights =
      'assets/qw_crystal/generated_icons/nav_insights.png';
  static const navMe = 'assets/qw_crystal/generated_icons/nav_me.png';

  static const drinkCoffee =
      'assets/qw_crystal/generated_icons/drink_coffee.png';
  static const drinkWaterGlass =
      'assets/qw_crystal/generated_icons/drink_water_glass.png';
  static const drinkWaterBottle =
      'assets/qw_crystal/generated_icons/drink_water_bottle.png';
  static const drinkTea = 'assets/qw_crystal/generated_icons/drink_tea.png';
  static const drinkMilk = 'assets/qw_crystal/generated_icons/drink_milk.png';
  static const drinkOrangeJuice =
      'assets/qw_crystal/generated_icons/drink_orange_juice.png';
  static const drinkBeer = 'assets/qw_crystal/generated_icons/drink_beer.png';
  static const drinkColdDrink =
      'assets/qw_crystal/generated_icons/drink_cold_drink.png';
  static const settingReminder =
      'assets/qw_crystal/generated_icons/setting_reminder.png';
  static const settingMuteNight =
      'assets/qw_crystal/generated_icons/setting_mute_night.png';
  static const settingDailyGoal =
      'assets/qw_crystal/generated_icons/setting_daily_goal.png';
  static const settingUnit =
      'assets/qw_crystal/generated_icons/setting_unit.png';
  static const settingFeedback =
      'assets/qw_crystal/generated_icons/setting_feedback.png';
  static const settingRecalculate =
      'assets/qw_crystal/generated_icons/setting_recalculate.png';

  static const insightWaterBalance =
      'assets/qw_crystal/generated_icons/insight_water_balance.png';
  static const insightSkinHydration =
      'assets/qw_crystal/generated_icons/insight_skin_hydration.png';
  static const insightSelfCare =
      'assets/qw_crystal/generated_icons/insight_self_care.png';

  static const homeHeroBottle =
      'assets/qw_crystal/generated_icons/home_hero_bottle.png';
  static const quick8Oz = 'assets/qw_crystal/generated_icons/quick_8oz.png';
  static const quick12Oz = 'assets/qw_crystal/generated_icons/quick_12oz.png';
  static const quick16Oz = 'assets/qw_crystal/generated_icons/quick_16oz.png';
  static const quick20Oz = 'assets/qw_crystal/generated_icons/quick_20oz.png';
  static const drinkSelectHero =
      'assets/qw_crystal/generated_icons/drink_select_hero.png';
  static const slideTallGlass =
      'assets/qw_crystal/generated_icons/slide_tall_glass.png';
  static const confirmWaterDrop =
      'assets/qw_crystal/generated_icons/confirm_water_drop.png';
  static const historyAnalytics =
      'assets/qw_crystal/generated_icons/history_analytics.png';
  static const historyRecord =
      'assets/qw_crystal/generated_icons/history_record.png';
  static const muteNightHero =
      'assets/qw_crystal/generated_icons/mute_night_hero.png';
  static const onboardingWeight =
      'assets/qw_crystal/generated_icons/onboarding_weight.png';
  static const onboardingActivity =
      'assets/qw_crystal/generated_icons/onboarding_activity.png';
  static const onboardingClimate =
      'assets/qw_crystal/generated_icons/onboarding_climate.png';
  static const sliderHandle =
      'assets/qw_crystal/generated_icons/slider_handle.png';
  static const removeAds = 'assets/qw_crystal/generated_icons/remove_ads.png';

  static String quickCupForOz(double oz) {
    if (oz <= 8) return quick8Oz;
    if (oz <= 12) return quick12Oz;
    if (oz <= 16) return quick16Oz;
    return quick20Oz;
  }

  static String? drinkIconFor(DrinkType type, {String? label}) {
    if (type == DrinkType.water) {
      final normalized = label?.toLowerCase() ?? '';
      if (normalized.contains('bottle')) return drinkWaterBottle;
      return drinkWaterGlass;
    }
    switch (type) {
      case DrinkType.tea:
        return drinkTea;
      case DrinkType.coffee:
        return drinkCoffee;
      case DrinkType.milk:
        return drinkMilk;
      case DrinkType.orangeJuice:
      case DrinkType.juice:
        return drinkOrangeJuice;
      case DrinkType.beer:
        return drinkBeer;
      case DrinkType.coldDrink:
        return drinkColdDrink;
      case DrinkType.custom:
      case DrinkType.water:
        return drinkWaterGlass;
    }
  }
}
