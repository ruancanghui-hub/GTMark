import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/date/calendar_month_service.dart';
import 'package:lianji/core/reminder/personal_reminder.dart';
import 'package:lianji/core/reminder/reminder_kind.dart';
import 'package:lianji/core/reminder/reminder_store.dart';
import 'package:lianji/modules/reminder/reminder_editor_sheet.dart';
import 'package:lianji/modules/date_detail/date_detail_page.dart';
import 'package:lianji/modules/main/main_controller.dart';
import 'package:lianji/modules/main/tabs/today/dated_plan_section.dart';
import 'package:lianji/modules/main/tabs/today_tab.dart';
import 'package:lianji/modules/main/today_controller.dart';
import 'package:get/get.dart';
import 'package:lianji/shared/utils/sp_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpEditor(
  WidgetTester tester, {
  required DateTime initialDate,
  PersonalReminder? initial,
  ReminderSaveCallback? saveReminder,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showReminderEditorSheet(
              context,
              saveReminder: saveReminder,
              initial:
                  initial ??
                  PersonalReminder(
                    id: 'draft',
                    title: '',
                    date: initialDate,
                    notifyEnabled: false,
                  ),
            ),
            child: const Text('打开编辑器'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('打开编辑器'));
  await tester.pumpAndSettle();
}

Future<void> pumpDateDetail(WidgetTester tester, DateTime date) async {
  Get.reset();
  Get.put(MainController());
  await tester.pumpWidget(GetMaterialApp(home: DateDetailPage(date: date)));
  await tester.pump();
}

Future<void> pumpDateDetailWithEditorResult(
  WidgetTester tester,
  DateTime date, {
  required Future<({bool saved, bool notifyPending})?> Function(
    BuildContext context, {
    PersonalReminder? existing,
    PersonalReminder? initial,
  })
  openPlanEditor,
  required Future<void> Function(BuildContext context) openNotificationSettings,
}) async {
  Get.reset();
  Get.put(MainController());
  await tester.pumpWidget(
    GetMaterialApp(
      home: DateDetailPage(
        date: date,
        openPlanEditor: openPlanEditor,
        openNotificationSettings: openNotificationSettings,
      ),
    ),
  );
  await tester.pump();
}

Future<void> fillAndSavePlan(
  WidgetTester tester, {
  required String title,
}) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, title);
  await tester.ensureVisible(find.text('到时提醒'));
  await tester.tap(find.text('到时提醒'));
  await tester.ensureVisible(find.text('保存'));
  await tester.tap(find.text('保存'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtils.getInstance();
    await SpUtils.clear();
  });

  test('plansOn normalizes date and sorts all-day first', () async {
    await ReminderStore.save(
      PersonalReminder(
        id: 'late',
        title: '晚间计划',
        date: DateTime(2026, 7, 8),
        hour: 20,
        notifyEnabled: false,
      ),
    );
    await ReminderStore.save(
      PersonalReminder(
        id: 'all',
        title: '全天计划',
        date: DateTime(2026, 7, 8),
        allDay: true,
        notifyEnabled: false,
      ),
    );

    expect(ReminderStore.plansOn(DateTime(2026, 7, 8, 23)).map((e) => e.id), [
      'all',
      'late',
    ]);
  });

  test('plansOn excludes anniversary kinds and sorts timed plans', () async {
    await ReminderStore.save(
      PersonalReminder(
        id: 'later-minute',
        title: '稍后',
        date: DateTime(2026, 7, 8),
        hour: 9,
        minute: 30,
        notifyEnabled: false,
      ),
    );
    await ReminderStore.save(
      PersonalReminder(
        id: 'birthday',
        title: '生日',
        date: DateTime(2026, 7, 8),
        kind: ReminderKind.birthday,
        notifyEnabled: false,
      ),
    );
    await ReminderStore.save(
      PersonalReminder(
        id: 'earlier-minute',
        title: '稍早',
        date: DateTime(2026, 7, 8),
        hour: 9,
        minute: 5,
        notifyEnabled: false,
      ),
    );
    await ReminderStore.save(
      PersonalReminder(
        id: 'other-day',
        title: '其他日期',
        date: DateTime(2026, 7, 9),
        notifyEnabled: false,
      ),
    );

    expect(ReminderStore.plansOn(DateTime(2026, 7, 8)).map((e) => e.id), [
      'earlier-minute',
      'later-minute',
    ]);
  });

  testWidgets('selected date is preserved and all-day hides time', (
    tester,
  ) async {
    await pumpEditor(tester, initialDate: DateTime(2026, 7, 18));

    expect(find.text('新建计划'), findsOneWidget);
    expect(find.byTooltip('关闭'), findsOneWidget);
    expect(find.textContaining('2026年7月18日'), findsOneWidget);
    await tester.tap(find.text('全天'));
    await tester.pump();

    expect(find.text('时间'), findsNothing);
  });

  testWidgets('saving a plan persists all-day and category', (tester) async {
    await pumpEditor(tester, initialDate: DateTime(2026, 7, 18));

    await tester.enterText(find.byType(TextField).first, '家庭旅行');
    await tester.tap(find.text('全天'));
    await tester.tap(find.text('旅行'));
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    final saved = ReminderStore.loadAll().single;
    expect(saved.date, DateTime(2026, 7, 18));
    expect(saved.allDay, isTrue);
    expect(saved.category, 'travel');
  });

  testWidgets('empty title keeps the dated plan form open', (tester) async {
    await pumpEditor(tester, initialDate: DateTime(2026, 7, 18));

    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.pump();

    expect(find.text('请填写提醒标题'), findsOneWidget);
    expect(find.textContaining('2026年7月18日'), findsOneWidget);
    expect(ReminderStore.loadAll(), isEmpty);
  });

  testWidgets('save failure keeps form and allows retry without duplicate', (
    tester,
  ) async {
    final firstAttempt = Completer<({bool saved, bool notifyPending})>();
    var attempts = 0;
    await pumpEditor(
      tester,
      initialDate: DateTime(2026, 7, 18),
      saveReminder: (reminder, {required isEditing}) {
        attempts++;
        if (attempts == 1) return firstAttempt.future;
        return Future.value((saved: true, notifyPending: false));
      },
    );
    await tester.enterText(find.byType(TextField).first, '家庭聚餐');
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.pump();
    expect(attempts, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    firstAttempt.completeError(StateError('disk full'));
    await tester.pumpAndSettle();
    expect(find.text('保存失败，请稍后重试'), findsOneWidget);
    expect(find.text('家庭聚餐'), findsOneWidget);
    expect(find.textContaining('2026年7月18日'), findsOneWidget);

    await tester.ensureVisible(find.text('重试'));
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('dated plan section exposes add edit and complete actions', (
    tester,
  ) async {
    final plan = PersonalReminder(
      id: 'plan',
      title: '家庭晚餐',
      date: DateTime(2026, 7, 18),
      hour: 18,
      notifyEnabled: false,
    );
    PersonalReminder? edited;
    PersonalReminder? completed;
    var added = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatedPlanSection(
            date: DateTime(2026, 7, 18),
            plans: [plan],
            onAdd: () => added = true,
            onEdit: (value) => edited = value,
            onComplete: (value) => completed = value,
          ),
        ),
      ),
    );

    expect(find.text('家庭晚餐'), findsOneWidget);
    await tester.tap(find.text('添加计划'));
    await tester.tap(find.byTooltip('编辑家庭晚餐'));
    await tester.tap(find.byTooltip('完成家庭晚餐'));
    expect(added, isTrue);
    expect(edited, same(plan));
    expect(completed, same(plan));
  });

  testWidgets('saved plan immediately appears on the selected date', (
    tester,
  ) async {
    Get.reset();
    final controller = Get.put(
      TodayController(
        monthLoader: (value) async => CalendarMonthService.build(value),
      ),
    );
    controller.selectDate(DateTime(2026, 7, 18));
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: TodayTab())),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('为所选日期添加计划'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '家庭聚餐');
    await tester.ensureVisible(find.text('到时提醒'));
    await tester.tap(find.text('到时提醒'));
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).last, const Offset(0, -420));
    await tester.pump();
    expect(find.text('家庭聚餐'), findsOneWidget);
    expect(find.textContaining('7月18日'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('plan-marker-2026-07-18')),
      findsOneWidget,
    );
  });

  testWidgets('date detail keeps context after saving a plan', (tester) async {
    await pumpDateDetail(tester, DateTime(2026, 7, 18));
    await tester.ensureVisible(find.text('添加计划'));
    await tester.tap(find.text('添加计划'));
    await fillAndSavePlan(tester, title: '家庭聚餐');

    expect(find.text('家庭聚餐'), findsOneWidget);
    expect(find.textContaining('2026年7月18日'), findsOneWidget);
    expect(Get.find<MainController>().currentIndex.value, 0);
  });

  testWidgets('date detail edits and saves a plan before deleting it', (
    tester,
  ) async {
    ({bool saved, bool notifyPending})? latestResult;
    await ReminderStore.save(
      PersonalReminder(
        id: 'detail-plan',
        title: '晚餐预订',
        date: DateTime(2026, 7, 18),
        notifyEnabled: false,
      ),
    );
    await pumpDateDetailWithEditorResult(
      tester,
      DateTime(2026, 7, 18),
      openPlanEditor: (context, {existing, initial}) async {
        latestResult = await showReminderEditorSheet(
          context,
          existing: existing,
          initial: initial,
        );
        return latestResult;
      },
      openNotificationSettings: (_) async {},
    );

    await tester.drag(find.byType(ListView).first, const Offset(0, -240));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('完成晚餐预订'));
    await tester.pumpAndSettle();
    expect(ReminderStore.loadAll().single.completed, isTrue);

    await tester.ensureVisible(find.byTooltip('编辑晚餐预订'));
    await tester.tap(find.byTooltip('编辑晚餐预订'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '晚餐改期');
    await tester.ensureVisible(find.text('保存'));
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('晚餐改期'), findsOneWidget);
    expect(ReminderStore.loadAll().single.title, '晚餐改期');
    expect(ReminderStore.loadAll().single.date, DateTime(2026, 7, 18));
    expect(Get.find<MainController>().currentIndex.value, 0);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('编辑晚餐改期'));
    await tester.tap(find.byTooltip('编辑晚餐改期'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('删除'));
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    expect(find.text('删除提醒'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, '删除').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(ReminderStore.loadAll(), isEmpty);
    expect(find.text('这一天还没有计划'), findsOneWidget);
    expect(latestResult?.saved, isFalse);
    expect(Get.find<MainController>().currentIndex.value, 0);
  });

  testWidgets('deleted editor result shows accurate feedback', (tester) async {
    await pumpDateDetailWithEditorResult(
      tester,
      DateTime(2026, 7, 18),
      openPlanEditor: (context, {existing, initial}) async =>
          (saved: false, notifyPending: false),
      openNotificationSettings: (_) async {},
    );

    await tester.ensureVisible(find.text('添加计划'));
    await tester.tap(find.text('添加计划'));
    await tester.pump();

    expect(find.text('计划已删除'), findsOneWidget);
    expect(find.text('计划已保存'), findsNothing);
  });

  testWidgets('notification failure offers an actionable settings recovery', (
    tester,
  ) async {
    var settingsOpened = false;
    await pumpDateDetailWithEditorResult(
      tester,
      DateTime(2026, 7, 18),
      openPlanEditor: (context, {existing, initial}) async =>
          (saved: true, notifyPending: true),
      openNotificationSettings: (context) async {
        settingsOpened = true;
      },
    );

    await tester.ensureVisible(find.text('添加计划'));
    await tester.tap(find.text('添加计划'));
    await tester.pump();

    expect(find.text('计划已保存；通知未开启时仅站内可见'), findsOneWidget);
    expect(find.widgetWithText(SnackBarAction, '去设置'), findsOneWidget);
    tester.widget<SnackBarAction>(find.byType(SnackBarAction)).onPressed();
    await tester.pump();
    expect(settingsOpened, isTrue);
  });

  testWidgets(
    'date detail creates plans with notification enabled by default',
    (tester) async {
      PersonalReminder? draft;
      await pumpDateDetailWithEditorResult(
        tester,
        DateTime(2026, 7, 18),
        openPlanEditor: (context, {existing, initial}) async {
          draft = initial;
          return null;
        },
        openNotificationSettings: (_) async {},
      );

      await tester.ensureVisible(find.text('添加计划'));
      await tester.tap(find.text('添加计划'));
      await tester.pump();
      expect(draft?.notifyEnabled, isTrue);
    },
  );

  testWidgets('home defaults notification on and offers settings recovery', (
    tester,
  ) async {
    PersonalReminder? draft;
    var settingsOpened = false;
    Get.reset();
    final controller = Get.put(
      TodayController(
        monthLoader: (value) async => CalendarMonthService.build(value),
      ),
    );
    controller.selectDate(DateTime(2026, 7, 18));
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: TodayTab(
            openPlanEditor: (context, {existing, initial}) async {
              draft = initial;
              return (saved: true, notifyPending: true);
            },
            openNotificationSettings: (_) async {
              settingsOpened = true;
            },
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('为所选日期添加计划'));
    await tester.pump();
    expect(draft?.notifyEnabled, isTrue);
    expect(find.widgetWithText(SnackBarAction, '去设置'), findsOneWidget);
    tester.widget<SnackBarAction>(find.byType(SnackBarAction)).onPressed();
    await tester.pump();
    expect(settingsOpened, isTrue);
  });
}
