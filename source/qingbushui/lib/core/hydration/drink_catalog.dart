import 'models.dart';
import 'volume_format.dart';

class DrinkPreset {
  const DrinkPreset({
    required this.type,
    required this.labelKey,
    required this.defaultOz,
    required this.section,
    required this.icon,
    required this.fillColor,
  });

  final DrinkType type;
  final String labelKey;
  final double defaultOz;
  final String section;
  final int icon;
  final int fillColor;

  @Deprecated('Use labelKey with AppLocalizations.drinkPresetLabel')
  String get label => labelKey;
}

class DrinkCatalog {
  static const int iconGlass = 0xe561;
  static const int iconCoffee = 0xe3ae;
  static const int iconLocalDrink = 0xe544;

  static List<DrinkPreset> all() => [
        const DrinkPreset(
          type: DrinkType.water,
          labelKey: 'smallGlass',
          defaultOz: 6,
          section: 'WATER',
          icon: iconGlass,
          fillColor: 0xFF1E88E5,
        ),
        const DrinkPreset(
          type: DrinkType.water,
          labelKey: 'standardGlass',
          defaultOz: 8,
          section: 'WATER',
          icon: iconGlass,
          fillColor: 0xFF1E88E5,
        ),
        const DrinkPreset(
          type: DrinkType.water,
          labelKey: 'largeGlass',
          defaultOz: 12,
          section: 'WATER',
          icon: iconLocalDrink,
          fillColor: 0xFF1E88E5,
        ),
        const DrinkPreset(
          type: DrinkType.tea,
          labelKey: 'tea',
          defaultOz: 6,
          section: 'OTHER',
          icon: iconLocalDrink,
          fillColor: 0xFF66BB6A,
        ),
        const DrinkPreset(
          type: DrinkType.coffee,
          labelKey: 'coffee',
          defaultOz: 8,
          section: 'OTHER',
          icon: iconCoffee,
          fillColor: 0xFF8D6E63,
        ),
        const DrinkPreset(
          type: DrinkType.milk,
          labelKey: 'milk',
          defaultOz: 8,
          section: 'OTHER',
          icon: iconLocalDrink,
          fillColor: 0xFF90CAF9,
        ),
        const DrinkPreset(
          type: DrinkType.orangeJuice,
          labelKey: 'orangeJuice',
          defaultOz: 8,
          section: 'OTHER',
          icon: iconLocalDrink,
          fillColor: 0xFFFF9800,
        ),
        const DrinkPreset(
          type: DrinkType.beer,
          labelKey: 'beer',
          defaultOz: 12,
          section: 'OTHER',
          icon: iconLocalDrink,
          fillColor: 0xFFFFC107,
        ),
        const DrinkPreset(
          type: DrinkType.coldDrink,
          labelKey: 'coldDrink',
          defaultOz: 16,
          section: 'OTHER',
          icon: iconLocalDrink,
          fillColor: 0xFF1565C0,
        ),
      ];

  static int defaultMl(DrinkType type) {
    final preset = all().firstWhere(
      (p) => p.type == type,
      orElse: () => all()[1],
    );
    return VolumeFormat.mlFromOz(preset.defaultOz);
  }
}
