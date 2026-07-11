import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  DrinkType _type = DrinkType.water;
  double _volume = 250;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加记录')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('饮品类型'),
            Wrap(
              spacing: 8,
              children: DrinkType.values
                  .map(
                    (t) => ChoiceChip(
                      label: Text(t.name),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('容量: ${_volume.round()} ml'),
            Slider(
              value: _volume,
              min: 50,
              max: 1000,
              divisions: 19,
              onChanged: (v) => setState(() => _volume = v),
            ),
            TextField(
              controller: _note,
              decoration: const InputDecoration(labelText: '备注（可选）'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                await HydrationStore.of().addIntake(
                  drinkType: _type,
                  volumeMl: _volume.round(),
                  note: _note.text.isEmpty ? null : _note.text,
                );
                Modular.to.pop();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
