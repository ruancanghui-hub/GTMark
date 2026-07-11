import 'models.dart';

class VolumeFormat {
  static const double mlPerOz = 29.5735;

  static int mlFromOz(double oz) => (oz * mlPerOz).round();

  static double ozFromMl(int ml) => ml / mlPerOz;

  static String display(int volumeMl, VolumeUnit unit) {
    if (unit == VolumeUnit.ml) return '$volumeMl ml';
    final oz = ozFromMl(volumeMl);
    final text = oz == oz.roundToDouble()
        ? '${oz.toInt()}'
        : oz.toStringAsFixed(1);
    return '$text oz';
  }

  static String displayOzCompact(int volumeMl) {
    final oz = ozFromMl(volumeMl);
    if (oz == oz.roundToDouble()) return '${oz.toInt()}';
    return oz.toStringAsFixed(1);
  }
}
