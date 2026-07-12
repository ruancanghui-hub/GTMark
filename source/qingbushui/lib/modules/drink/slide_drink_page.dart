import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../l10n/app_localizations.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/hydration/volume_format.dart';
import '../../shared/widgets/slide_to_drink.dart';
import '../../shared/widgets/qw_screen_shell.dart';
import '../../shared/widgets/wt_drink_button.dart';
import '../../app/qing_theme.dart';

class SlideDrinkPage extends StatefulWidget {
  const SlideDrinkPage({super.key});

  @override
  State<SlideDrinkPage> createState() => _SlideDrinkPageState();
}

class _SlideDrinkPageState extends State<SlideDrinkPage> {
  late DrinkType _type;
  late double _oz;
  static const _minOz = 1.0;
  static const _maxOz = 32.0;

  @override
  void initState() {
    super.initState();
    final args = Modular.args.data as Map<String, dynamic>? ?? {};
    _type = DrinkType.values[args['type'] as int? ?? 0];
    _oz = (args['oz'] as num?)?.toDouble() ?? 8;
  }

  Future<void> _confirm() async {
    await HydrationStore.of().addIntake(
      drinkType: _type,
      volumeMl: VolumeFormat.mlFromOz(_oz),
    );
    if (mounted) {
      Modular.to.popUntil(
        (route) => route.settings.name == '/main/' || route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ozText = _oz == _oz.roundToDouble()
        ? '${_oz.toInt()}'
        : _oz.toStringAsFixed(1);
    return Scaffold(
      body: QwScreenShell(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.36),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Modular.to.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.tuneAmount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: QwColors.primaryDeep.withValues(alpha: 0.12),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    ozText,
                    style: const TextStyle(
                      color: QwColors.ink,
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'oz',
                    style: TextStyle(
                      fontSize: 20,
                      color: QwColors.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 8,
                ),
                child: SlideToDrink(
                  oz: _oz,
                  minOz: _minOz,
                  maxOz: _maxOz,
                  onChanged: (v) => setState(() => _oz = v.round().toDouble()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
              child: WtDrinkButton(onPressed: _confirm),
            ),
          ],
        ),
      ),
    );
  }
}
