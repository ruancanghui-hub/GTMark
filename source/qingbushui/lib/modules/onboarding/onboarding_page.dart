import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../app/qing_theme.dart';
import '../../core/hydration/goal_calculator.dart';
import '../../core/hydration/hydration_store.dart';
import '../../core/hydration/models.dart';
import '../../core/hydration/volume_format.dart';
import '../../shared/assets/qw_assets.dart';
import '../../shared/visuals/qw_water_bottle_hero.dart';
import '../../shared/widgets/qw_asset_icon.dart';
import '../../shared/widgets/qw_screen_shell.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Gender _gender = Gender.female;
  double _weightLbs = 145;
  ActivityLevel _activity = ActivityLevel.medium;
  Climate _climate = Climate.cold;
  late int _goalMl;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  void _recalc() {
    _goalMl = GoalCalculator.calculateDailyGoalMl(
      weightKg: _weightLbs * 0.453592,
      activityLevel: _activity,
      gender: _gender,
      climate: _climate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalOz = VolumeFormat.display(_goalMl, VolumeUnit.oz);
    return Scaffold(
      body: QwScreenShell(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const QwWaterBottleHero(progress: 0.72, size: 150),
              const SizedBox(height: 10),
              const Text(
                'Your daily goal is',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    goalOz.replaceAll(' oz', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const Text(
                    ' oz',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                child: InkWell(
                  onTap: () => setState(_recalc),
                  borderRadius: BorderRadius.circular(28),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Center(
                      child: Text(
                        'Calculate',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _card(
                      _gender == Gender.female ? 'Female' : 'Male',
                      badge: _gender == Gender.female ? 'F' : 'M',
                      onTap: () => setState(() {
                        _gender = _gender == Gender.female
                            ? Gender.male
                            : Gender.female;
                        _recalc();
                      }),
                    ),
                    _card(
                      '${_weightLbs.toInt()} lbs',
                      asset: QwAssets.onboardingWeight,
                      onTap: () => _pickWeight(),
                    ),
                    _card(
                      _activityLabel(),
                      asset: QwAssets.onboardingActivity,
                      onTap: () => setState(() {
                        _activity =
                            ActivityLevel.values[(_activity.index + 1) % 3];
                        _recalc();
                      }),
                    ),
                    _card(
                      _climate.name[0].toUpperCase() +
                          _climate.name.substring(1),
                      asset: QwAssets.onboardingClimate,
                      onTap: () => setState(() {
                        _climate = Climate.values[(_climate.index + 1) % 3];
                        _recalc();
                      }),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _finish,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: Color(0xFFFFD66B),
                  foregroundColor: QwColors.ink,
                ),
                child: const Text(
                  'Start hydrating',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _activityLabel() {
    switch (_activity) {
      case ActivityLevel.low:
        return 'Sedentary';
      case ActivityLevel.medium:
        return 'Exercises';
      case ActivityLevel.high:
        return 'Athlete';
    }
  }

  Widget _card(
    String label, {
    String? asset,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (asset != null)
                QwAssetIcon(asset: asset, label: '$label icon', size: 58)
              else
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: QwGradients.primary,
                  ),
                  child: Center(
                    child: Text(
                      badge ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: QwColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickWeight() async {
    var temp = _weightLbs;
    await showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModal) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${temp.toInt()} lbs', style: const TextStyle(fontSize: 24)),
              Slider(
                value: temp,
                min: 80,
                max: 250,
                divisions: 170,
                onChanged: (v) => setModal(() => temp = v),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _weightLbs = temp;
                    _recalc();
                  });
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finish() async {
    await HydrationStore.of().saveProfile(
      UserProfile(
        weightKg: _weightLbs * 0.453592,
        activityLevel: _activity,
        dailyGoalMl: _goalMl,
        onboardingDone: true,
        gender: _gender,
        climate: _climate,
      ),
    );
    Modular.to.navigate('/main/');
  }
}
