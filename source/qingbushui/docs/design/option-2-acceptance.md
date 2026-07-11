# Option 2 Redesign Acceptance

Date: 2026-07-11

## Visual Direction

Selected reference:

`source/qingbushui/assets/design_refs/option-2-qing-water-dashboard.png`

The app now uses the selected blue-white premium hydration style across the core shell:

- Bright blue-to-white gradient surfaces.
- Glossy 3D-inspired water bottle hero on Today.
- Option 2 Splash entry with the same water bottle hero and brand copy.
- White rounded daily goal pill.
- Translucent glass chips.
- Soft rounded hydration card.
- Raised center Add button in the bottom navigation.
- Redesigned drink selection cards and slide amount handle.
- Today recent intake list with rounded drink rows.
- Unified Option 2 bottom navigation on Today, History, Insights, and Me.
- Option 2 onboarding treatment with water-bottle hero and white profile cards.
- Option 2 reminder settings treatment with rounded white setting cards.

## Functional Coverage

- Today dashboard: progress, daily goal, quick add, add-drink entry.
- Today records: recent intake rows with drink type, time, and amount.
- Drink selection: water and other drink categories.
- Slide amount: draggable water amount control and confirm action.
- History: day/week/month chart and intake list remain wired to `HydrationStore`.
- Insights: educational card sections remain present.
- Me/settings: unit, daily goal, reminders, mute at night, recalculate goal, remove ads placeholder.
- Reminder settings and mute at night remain persisted through `HydrationStore`.
- Onboarding goal calculation remains wired to `GoalCalculator` and profile save.

## Remotion Motion Spec

Remotion project:

`source/qingbushui_motion`

Composition:

`QingWaterMotion`

Covered motion:

- Header and goal pill entry.
- Water bottle hero entry.
- Hydration progress fill.
- Hydration card pulse.
- Progress bar fill.

Rendered still:

`source/qingbushui_motion/out/frame45.png`

## Verification

Commands run:

```bash
cd source/qingbushui
flutter test
flutter analyze
flutter build apk --debug
```

Results:

- `flutter test`: passed, 11 tests.
- `flutter analyze`: passed, no issues.
- `flutter build apk --debug`: passed, output at `build/app/outputs/flutter-apk/app-debug.apk`.

```bash
cd source/qingbushui_motion
npm run typecheck
npm run still -- --output=out/frame45.png
```

Results:

- `npm run typecheck`: passed.
- `npm run still -- --output=out/frame45.png`: passed.

## Remaining Polish

The app is functionally connected and compiles. The remaining high-value polish is visual QA from real simulator/device screenshots, especially:

- Fine-tune History chart colors on the lighter Option 2 background.
- Capture 390x844 screenshots of all 8 target screens and compare against the selected design direction.
