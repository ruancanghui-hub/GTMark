import 'content_repository.dart';
import 'blessing_entry.dart';

abstract final class BlessingResolver {
  static BlessingTemplate generic() =>
      ContentRepository.instance.blessingTemplate('bls_generic')!;

  static BlessingTemplate? forFestivalId(String festivalId) =>
      ContentRepository.instance.blessingForFestivalId(festivalId);

  static BlessingTemplate? forBirthdayRelation(String relation) =>
      ContentRepository.instance.blessingTemplate('bls_bd_$relation');

  static BlessingTemplate? forAnniversarySubtype(String subtype) =>
      ContentRepository.instance.blessingTemplate('bls_an_$subtype');

  static BlessingTemplate? forCountdownTheme(String theme) =>
      ContentRepository.instance.blessingTemplate(
        'bls_cd_${theme == 'time' || theme == 'travel' || theme == 'exam' ? theme : 'time'}',
      );

  static String render({
    required BlessingTemplate template,
    required bool useSms,
    String chengHu = '您',
    String festivalName = '佳节',
    String typeName = '纪念日',
    String countdownDays = '',
  }) {
    return template.render(
      useSms: useSms,
      vars: {
        '称呼': chengHu,
        '节日名': festivalName,
        '类型名': typeName,
        '倒数天': countdownDays,
      },
    );
  }
}
