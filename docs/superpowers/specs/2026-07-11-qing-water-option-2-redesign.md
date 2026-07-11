# Qing Water Option 2 Redesign Spec

## Goal

Build a complete Flutter hydration tracker app from the existing `source/qingbushui` project using the selected Option 2 visual direction: a premium blue-white mobile UI with a glossy 3D water-bottle companion, soft glassy controls, airy spacing, and a raised center add button.

## Visual Target

Reference asset: `source/qingbushui/assets/design_refs/option-2-qing-water-dashboard.png`.

The app should feel like a polished Chinese mobile wellness product rather than a utilitarian clone. It must preserve the reference product's hydration functions while using original visuals, copy, icons, and motion.

Core visual rules:

- Use a bright top blue to white vertical gradient on primary screens.
- Use one large glossy 3D-inspired water bottle or water vessel motif on Today and onboarding.
- Use white rounded goal/search pills and translucent blue chips.
- Use soft shadows, low-contrast separators, and large 20-28 px rounded containers.
- Use a white bottom navigation bar with a raised circular blue Add button in the center.
- Keep text readable and non-gibberish; primary UI copy may be English for now.
- Avoid copying Google Play screenshots, original competitor branding, pet/dog visual language, or exact screenshot layout.

## Product Scope

The app must include these functional surfaces:

- Splash and onboarding goal calculation.
- Today dashboard with hydration progress, quick add amounts, daily goal, and add drink entry.
- Drink selection grid with water and other drink types.
- Slide-to-add drink amount control with animated water level.
- History with day/week/month statistics, chart, totals, and intake list.
- Insights with educational cards.
- Me/settings with units, goal, reminders, ads placeholder, and reset onboarding.
- Reminder settings and night mute time picker.

## Flutter Architecture

Keep the existing Flutter project and domain layer:

- `core/hydration/*` remains the source of truth for profile, records, goals, stats, and units.
- `flutter_modular` remains the routing mechanism.
- Shared UI should live under `lib/shared/widgets` and `lib/shared/visuals`.
- Feature screens stay under `lib/modules/*`.

Add a focused design system layer:

- Color tokens and gradients in `app/qing_theme.dart`.
- Reusable shell/background widgets for the Option 2 style.
- Reusable progress, chip, card, bottom nav, and 3D-inspired water illustration widgets.

## Motion

Flutter app motion:

- Today progress ring and water-bottle fill animate on entry and after intake changes.
- Quick add buttons press with a small scale/tint response.
- Add drink center button uses a spring-like lift/press response.
- Slide drink handle updates water level continuously while dragging.
- Bottom tab switches use subtle fade/slide transitions.
- Night mute wheel highlights the selected time with a soft glowing strip.

Remotion deliverable:

- Add a separate Remotion demo that documents and previews the app motion style.
- It should show Today progress entry, quick add pulse, slide amount water fill, and bottom add button lift.
- The demo is not the production runtime; it is the motion specification and optional promotional render source.

## Testing And Verification

Behavior tests:

- Existing hydration goal and stats tests must continue to pass.
- Add widget tests for Today quick add, drink selection navigation, slide amount confirmation, and unit/goal display where practical.

Verification:

- Run `flutter test`.
- Run `flutter analyze`.
- Run at least one build or smoke run that proves the app compiles.
- For Remotion, run a still render or equivalent compile check.

## Acceptance Criteria

The work is complete only when:

- The primary screens match the Option 2 visual language, not the older plain clone style.
- All listed functional surfaces are present and connected.
- Hydration records can be added from quick add, drink selection, and slide amount.
- Stats and history reflect added records.
- Reminders and night mute settings persist locally.
- Remotion motion demo exists and verifies successfully.
- Tests and analyzer pass, or any remaining failure is documented with the exact blocker.
