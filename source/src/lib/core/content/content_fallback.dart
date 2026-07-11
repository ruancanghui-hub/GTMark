import 'blessing_entry.dart';
import 'poem_entry.dart';

/// JSON 损坏或未命中时的最小硬编码降级。
abstract final class ContentFallback {
  static const poemDuanwu = PoemBundle(
    id: 'tf_duanwu',
    name: '端午节',
    category: 'traditional',
    tone: 'festive',
    figureName: '屈原',
    figureEra: '战国',
    poems: [
      PoemEntry(
        id: 'fallback-duanwu',
        text: '路漫漫其修远兮，吾将上下而求索。',
        author: '屈原',
        source: '离骚',
        byFigure: true,
        isDefault: true,
      ),
    ],
  );

  static const blessingGeneric = BlessingTemplate(
    id: 'bls_generic',
    scene: 'generic',
    tone: 'festive',
    wechat: BlessingTrack(
      text: '{称呼}，{节日名}快乐！',
      maxChars: 50,
      emojiAllowed: true,
    ),
    sms: BlessingTrack(
      text: '{称呼}，祝您{节日名}快乐，一切顺意。',
      maxChars: 70,
      emojiAllowed: false,
    ),
  );
}
