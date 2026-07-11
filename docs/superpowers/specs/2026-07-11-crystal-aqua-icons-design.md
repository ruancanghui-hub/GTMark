# Crystal Aqua 3D Icon System Spec

## Goal

Replace Qing Water's weak default icon treatment with the selected Crystal Aqua 3D design board from `/Users/nightelf/Downloads/已生成图像 4 (1).png`.

## Visual Target

Use the board as the source of truth:

- Crystal-clear blue water objects.
- Semi-realistic transparent glass and liquid materials.
- Soft blue shadows and white surfaces.
- Consistent front three-quarter icon angle.
- Rounded premium wellness app feel.

## Asset Scope

Create project assets for:

- Drink icons: water glass, water bottle, tea, coffee, milk, orange juice, beer, cold drink.
- Settings/reminder icons: reminder, mute at night, daily goal, unit, feedback, recalculate.
- Insights illustrations: water balance, skin hydration, self care.
- Bottom navigation icons: today, history, add, insights, me.
- Brand/hero helpers: app water drop and bottle hero where useful.

## Flutter Integration

- Store source board and cropped icons under `source/qingbushui/assets/qw_crystal/`.
- Declare assets in `source/qingbushui/pubspec.yaml`.
- Add a reusable `QwAssetIcon` widget to centralize `Image.asset` sizing and accessibility labels.
- Replace default Material icon usage where the selected visual board provides a better 3D asset.
- Keep simple functional icons only where the board has no corresponding asset.

## Verification

- Widget test must prove Crystal assets render in bottom navigation and drink selection.
- `flutter test`, `flutter analyze`, and `flutter build apk --debug` must pass.
