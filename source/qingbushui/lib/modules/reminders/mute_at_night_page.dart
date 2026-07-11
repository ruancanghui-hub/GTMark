import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app/qing_theme.dart';
import '../../core/hydration/hydration_store.dart';

class MuteAtNightPage extends StatefulWidget {
  const MuteAtNightPage({super.key});

  @override
  State<MuteAtNightPage> createState() => _MuteAtNightPageState();
}

class _MuteAtNightPageState extends State<MuteAtNightPage> {
  late final HydrationStore _store;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _store = HydrationStore.of();
    _hour = _store.reminders.muteEndHour;
    _minute = _store.reminders.muteEndMinute;
  }

  Future<void> _save() async {
    await _store.saveReminders(
      _store.reminders.copyWith(
        muteAtNight: true,
        muteEndHour: _hour,
        muteEndMinute: _minute,
      ),
    );
    if (mounted) Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: WtColors.nightGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Mute at night'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.notifications_off, color: Colors.white, size: 48),
            const SizedBox(height: 24),
            const Text(
              'When do you usually end a day?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _wheel(
                    value: _hour,
                    max: 23,
                    onChanged: (v) => setState(() => _hour = v),
                  ),
                  const Text(
                    ' : ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _wheel(
                    value: _minute,
                    max: 59,
                    step: 15,
                    onChanged: (v) => setState(() => _minute = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: WtColors.blueMid,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _save,
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wheel({
    required int value,
    required int max,
    int step = 1,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 80,
      height: 160,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 48,
        perspective: 0.003,
        diameterRatio: 1.4,
        onSelectedItemChanged: (i) => onChanged(i * step),
        controller: FixedExtentScrollController(initialItem: value ~/ step),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: (max ~/ step) + 1,
          builder: (_, i) {
            final v = i * step;
            final selected = v == value;
            return Center(
              child: Text(
                v.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: selected ? 1 : 0.35),
                  fontSize: selected ? 32 : 24,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
