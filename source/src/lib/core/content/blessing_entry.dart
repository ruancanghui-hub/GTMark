import 'package:characters/characters.dart';

/// 祝福库模板（微信版 + 短信版）。
class BlessingTrack {
  const BlessingTrack({
    required this.text,
    required this.maxChars,
    required this.emojiAllowed,
  });

  final String text;
  final int maxChars;
  final bool emojiAllowed;

  factory BlessingTrack.fromJson(Map<String, dynamic> json) {
    return BlessingTrack(
      text: json['text'] as String,
      maxChars: json['maxChars'] as int? ?? 50,
      emojiAllowed: json['emojiAllowed'] as bool? ?? true,
    );
  }
}

class BlessingTemplate {
  const BlessingTemplate({
    required this.id,
    required this.scene,
    required this.tone,
    required this.wechat,
    required this.sms,
    this.relation,
    this.subtype,
    this.refPoemId,
    this.refFestivalId,
  });

  final String id;
  final String scene;
  final String tone;
  final BlessingTrack wechat;
  final BlessingTrack sms;
  final String? relation;
  final String? subtype;
  final String? refPoemId;
  final String? refFestivalId;

  factory BlessingTemplate.fromJson(String id, Map<String, dynamic> json) {
    return BlessingTemplate(
      id: id,
      scene: json['scene'] as String? ?? 'generic',
      tone: json['tone'] as String? ?? 'festive',
      wechat: BlessingTrack.fromJson(
        Map<String, dynamic>.from(json['wechat'] as Map),
      ),
      sms: BlessingTrack.fromJson(
        Map<String, dynamic>.from(json['sms'] as Map),
      ),
      relation: json['relation'] as String?,
      subtype: json['subtype'] as String?,
      refPoemId: json['refPoemId'] as String?,
      refFestivalId: json['refFestivalId'] as String?,
    );
  }

  String render({required bool useSms, required Map<String, String> vars}) {
    final track = useSms ? sms : wechat;
    var out = track.text;
    vars.forEach((k, v) {
      out = out.replaceAll('{$k}', v);
    });
    final len = out.characters.length;
    if (len > track.maxChars) {
      out = out.characters.take(track.maxChars).toString();
    }
    return out;
  }

  /// 渲染后字数（占位符替换后）。
  int renderedLength({required bool useSms, required Map<String, String> vars}) {
    return render(useSms: useSms, vars: vars).characters.length;
  }
}
