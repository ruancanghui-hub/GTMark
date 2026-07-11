# Qing Water Option 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the existing Flutter hydration tracker into the selected Option 2 blue-white 3D water-bottle style and add a Remotion motion demo.

**Architecture:** Keep the current Flutter domain layer, routing, and modules. Add an Option 2 design system and replace screen-level presentation while preserving hydration behavior. Remotion lives in a separate project folder and serves as a motion specification.

**Tech Stack:** Flutter, Dart, flutter_modular, Hive/shared_preferences, fl_chart, Remotion, React, TypeScript.

## Global Constraints

- Use `source/qingbushui` as the app root.
- Preserve `core/hydration/*` behavior unless a failing test proves a bug.
- Use `source/qingbushui/assets/design_refs/option-2-qing-water-dashboard.png` as the visual target.
- Do not copy competitor branding, Google Play screenshots, pet/dog visuals, or exact reference layout.
- Write failing tests before production behavior changes.
- Verify with `flutter test`, `flutter analyze`, and a Remotion still/compile check.

---

### Task 1: Option 2 Design System

**Files:**
- Modify: `source/qingbushui/lib/app/qing_theme.dart`
- Create: `source/qingbushui/lib/shared/widgets/qw_screen_shell.dart`
- Create: `source/qingbushui/lib/shared/widgets/qw_glass_chip.dart`
- Create: `source/qingbushui/lib/shared/widgets/qw_bottom_nav.dart`
- Create: `source/qingbushui/lib/shared/visuals/qw_water_bottle_hero.dart`
- Test: `source/qingbushui/test/option2_design_system_test.dart`

**Interfaces:**
- Produces: `QwColors`, `QwGradients`, `QwScreenShell`, `QwGlassChip`, `QwBottomNav`, `QwWaterBottleHero`.
- Consumes: existing Material widgets and app theme.

- [ ] Add a widget smoke test that pumps `QwScreenShell`, `QwGlassChip`, `QwBottomNav`, and `QwWaterBottleHero`.
- [ ] Run the test and confirm it fails because the new widgets do not exist.
- [ ] Implement the new design tokens and widgets with Option 2 gradients, pills, shadows, and raised center Add button.
- [ ] Re-run the test and confirm it passes.

### Task 2: Today Dashboard Redesign

**Files:**
- Modify: `source/qingbushui/lib/modules/home/home_tab.dart`
- Modify: `source/qingbushui/lib/shared/widgets/water_progress_ring.dart`
- Modify: `source/qingbushui/lib/shared/widgets/wt_drink_button.dart`
- Test: `source/qingbushui/test/today_dashboard_test.dart`

**Interfaces:**
- Consumes: `HydrationStore`, `VolumeFormat`, `QwScreenShell`, `QwBottomNav`, `QwWaterBottleHero`.
- Produces: Option 2 Today screen with quick add and add-drink navigation.

- [ ] Add tests for visible Today labels, progress status, quick add action, and Add button presence.
- [ ] Run the test and confirm the new Option 2 labels/widgets are missing.
- [ ] Rebuild Today around the Option 2 hero, goal pill, translucent chips, progress status, quick add card, and raised Add navigation.
- [ ] Re-run the Today test and existing hydration tests.

### Task 3: Drink Selection And Slide Add Redesign

**Files:**
- Modify: `source/qingbushui/lib/modules/drink/drink_select_page.dart`
- Modify: `source/qingbushui/lib/modules/drink/slide_drink_page.dart`
- Modify: `source/qingbushui/lib/shared/widgets/slide_to_drink.dart`
- Test: `source/qingbushui/test/drink_flow_test.dart`

**Interfaces:**
- Consumes: drink catalog, `HydrationStore.addIntake`, `QwGlassChip`.
- Produces: selection grid and animated slide amount flow.

- [ ] Add tests for drink category labels, selecting a drink, dragging/changing amount, and confirmation.
- [ ] Run the tests and confirm missing Option 2 labels or interaction expectations fail.
- [ ] Redesign selection as white/blue rounded grid cards and slide add as glossy bottle/water control.
- [ ] Re-run drink flow tests.

### Task 4: History, Insights, Me, Reminder Screens

**Files:**
- Modify: `source/qingbushui/lib/modules/stats/history_tab.dart`
- Modify: `source/qingbushui/lib/modules/insights/insights_tab.dart`
- Modify: `source/qingbushui/lib/modules/me/me_tab.dart`
- Modify: `source/qingbushui/lib/modules/reminders/reminder_settings_page.dart`
- Modify: `source/qingbushui/lib/modules/reminders/mute_at_night_page.dart`
- Test: `source/qingbushui/test/secondary_surfaces_test.dart`

**Interfaces:**
- Consumes: stats service, settings persistence, reminder persistence.
- Produces: complete functional secondary surfaces in the Option 2 style.

- [ ] Add tests for day/week/month tabs, insights cards, Me settings labels, reminder slots, and mute save.
- [ ] Run tests and confirm the new surface expectations fail.
- [ ] Apply the Option 2 design system to each secondary screen while preserving existing behavior.
- [ ] Re-run the secondary surface tests and existing domain tests.

### Task 5: Onboarding And Splash Polish

**Files:**
- Modify: `source/qingbushui/lib/modules/onboarding/onboarding_page.dart`
- Modify: `source/qingbushui/lib/modules/splash/splash_page.dart`
- Test: `source/qingbushui/test/onboarding_visual_flow_test.dart`

**Interfaces:**
- Consumes: goal calculator and profile storage.
- Produces: Option 2 onboarding with large 3D-inspired bottle/goal treatment.

- [ ] Add tests for onboarding goal calculation controls and completion path.
- [ ] Run tests and confirm new expectations fail.
- [ ] Redesign onboarding and splash with the new visual language.
- [ ] Re-run onboarding tests.

### Task 6: Remotion Motion Demo

**Files:**
- Create: `source/qingbushui_motion/package.json`
- Create: `source/qingbushui_motion/src/Root.tsx`
- Create: `source/qingbushui_motion/src/QingWaterMotion.tsx`

**Interfaces:**
- Produces: Remotion composition `QingWaterMotion` at 1080x1920, 30 fps.

- [ ] Scaffold a blank Remotion project or minimal Remotion package.
- [ ] Implement a motion demo with progress entry, quick add pulse, slide amount fill, and raised Add button lift using `useCurrentFrame()` and `interpolate()`.
- [ ] Run a still render at frame 45 to verify layout.

### Task 7: Final Verification

**Files:**
- Modify: `source/qingbushui/docs/ACCEPTANCE_REPORT.md`
- Create: `source/qingbushui/docs/design/option-2-acceptance.md`

**Interfaces:**
- Consumes: all previous tasks.
- Produces: final evidence and handoff notes.

- [ ] Run `flutter test`.
- [ ] Run `flutter analyze`.
- [ ] Run a compile/build smoke check.
- [ ] Run the Remotion still/compile check.
- [ ] Update acceptance documentation with exact commands and results.
