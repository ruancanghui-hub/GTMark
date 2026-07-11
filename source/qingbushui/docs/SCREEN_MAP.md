# SCREEN_MAP — 截图 → 路由 → Widget 树

| 截图 | 路由 | 根 Widget | 子树 |
|------|------|-----------|------|
| S02 | `/main/` index 0 | `HomeTab` | `WtGradientBackground` → `WaterProgressRing` → `QuickPresetRow` → `WtDrinkButton` → `WtBottomNav` |
| S04 | `/drink/slide` | `SlideDrinkPage` | `AppBar(back)` → `SlideAmountDisplay` → `SlideToDrink` → `WtDrinkButton` |
| S01 | `/drink/select` | `DrinkSelectPage` | `AppBar` → `DrinkSection(WATER)` → `DrinkSection(OTHER)` → `WaveFooter` |
| S06 | `/main/` index 1 | `HistoryTab` | `WtGradientBackground` → `WtTabBar(Day/Week/Month)` → `StatsSummary` → `StatsLineChart` → `HistoryList` |
| S08 | `/main/` index 2 | `InsightsTab` | `Scaffold(white)` → `InsightsHeader` → `InsightCarousel×3` |
| S02 Me | `/main/` index 3 | `MeTab` | `ListView` → `MeListTile×N` |
| S05 | `/onboarding/` | `OnboardingPage` | `WtGradientBackground` → `GoalDisplay` → `CalculateButton` → `ProfileGrid2×2` |
| S07 | `/reminders/mute` | `MuteAtNightPage` | `NightGradient` → `TimeWheelPicker` → `SaveButton` |
| S03 | `/reminders/` | `ReminderSettingsPage` | `ReminderSlotList` → `MuteAtNightTile` |

## 模块注册 (flutter_modular)

```
/main/          MainModule → MainPage
/drink/select   DrinkModule
/drink/slide    DrinkModule
/onboarding/    OnboardingModule
/reminders/     ReminderModule
/reminders/mute ReminderModule
```

## 导航流

```
Splash → Onboarding (首次) → Main
Main.Today → [+DRINK] → DrinkSelect → SlideDrink → pop → Today 刷新
Main.Me → Mute at night → MuteAtNightPage
```
