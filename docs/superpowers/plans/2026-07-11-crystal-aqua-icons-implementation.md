# Crystal Aqua 3D Icon System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Qing Water's default-looking icons with the selected Crystal Aqua 3D asset system.

**Architecture:** Crop implementation-ready PNG assets from the selected design board, declare them in Flutter, and route app UI through a shared asset icon component. Preserve all existing hydration behavior.

**Tech Stack:** Flutter, Dart, PNG assets, Python Pillow for one-time crop extraction.

## Global Constraints

- Use `/Users/nightelf/Downloads/已生成图像 4 (1).png` as the selected visual source.
- Keep all generated/cropped assets inside `source/qingbushui/assets/qw_crystal/`.
- Do not hotlink external images.
- Do not remove existing behavior while replacing icons.
- Run `flutter test`, `flutter analyze`, and `flutter build apk --debug`.

---

### Task 1: Asset Extraction

**Files:**
- Create: `source/qingbushui/assets/qw_crystal/source/crystal-aqua-board.png`
- Create: `source/qingbushui/assets/qw_crystal/icons/*.png`

**Interfaces:**
- Produces: stable PNG files for Flutter `Image.asset`.

- [ ] Copy the selected board into the project.
- [ ] Crop drink, navigation, settings, and insights assets from the board.
- [ ] Remove near-white board backgrounds to alpha while preserving soft shadows.

### Task 2: Flutter Asset Layer

**Files:**
- Modify: `source/qingbushui/pubspec.yaml`
- Create: `source/qingbushui/lib/shared/assets/qw_assets.dart`
- Create: `source/qingbushui/lib/shared/widgets/qw_asset_icon.dart`
- Test: `source/qingbushui/test/crystal_assets_test.dart`

**Interfaces:**
- Produces: `QwAssets` constants and `QwAssetIcon`.

- [ ] Add failing widget test for rendering a crystal drink icon and nav icon.
- [ ] Declare asset folders in `pubspec.yaml`.
- [ ] Implement constants and reusable image widget.
- [ ] Re-run the test.

### Task 3: UI Replacement

**Files:**
- Modify: `source/qingbushui/lib/shared/widgets/qw_bottom_nav.dart`
- Modify: `source/qingbushui/lib/modules/drink/drink_select_page.dart`
- Modify: `source/qingbushui/lib/modules/home/home_tab.dart`
- Modify: `source/qingbushui/lib/modules/insights/insights_tab.dart`
- Modify: `source/qingbushui/lib/modules/me/me_tab.dart`
- Modify: `source/qingbushui/lib/modules/reminders/reminder_settings_page.dart`

**Interfaces:**
- Consumes: `QwAssets` and `QwAssetIcon`.
- Produces: app screens that use the Crystal Aqua 3D icons instead of weak default Material icons.

- [ ] Replace bottom navigation glyphs with selected nav assets.
- [ ] Replace drink grid icons with cropped drink assets.
- [ ] Replace recent drink and settings/reminder glyphs where matching assets exist.
- [ ] Replace Insights cards with selected illustration assets.

### Task 4: Verification

**Files:**
- Modify: `source/qingbushui/docs/design/option-2-acceptance.md`

**Interfaces:**
- Produces: fresh verification evidence.

- [ ] Run `flutter test`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter build apk --debug`.
- [ ] Update acceptance notes.
