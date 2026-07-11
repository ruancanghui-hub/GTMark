import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_entry.dart';
import 'package:lianji/modules/share/share_card_args.dart';
import 'package:lianji/modules/share/share_card_capture.dart';
import 'package:lianji/modules/share/share_card_model.dart';
import 'package:lianji/modules/share/share_card_tone.dart';
import 'package:lianji/modules/share/share_card_widget.dart';
import 'package:lianji/modules/share/share_png_utils.dart';

const _qingmingPoem = '''
{
  "version": 1,
  "festivals": {
    "tf_qingming": {
      "name": "清明节",
      "category": "traditional",
      "tone": "solemn",
      "poems": [{
        "id": "tf_qingming-01",
        "text": "清明时节雨纷纷，路上行人欲断魂。",
        "author": "杜牧",
        "default": true
      }]
    }
  }
}
''';

ShareCardModel _sampleModel({PoemBundle? bundle, String? festivalId}) =>
    ShareCardModel(
      date: DateTime(2026, 4, 4),
      kind: ShareCardKind.dateDetail,
      headline: '清明节',
      solarLine: '2026年4月4日',
      lunarLine: '农历',
      weekday: '周六',
      poemBundle: bundle,
      festivalId: festivalId,
    );

void main() {
  setUp(() async {
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init(
      poemsJson: _qingmingPoem,
      blessingsJson: '{"version":1,"templates":{}}',
    );
  });

  test('SharePngUtils reads IHDR dimensions', () {
    // Minimal valid 1x1 PNG
    final png = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x04, 0x38, // 1080
      0x00, 0x00, 0x04, 0x38, // 1080
      0x08, 0x06, 0x00, 0x00, 0x00,
    ]);
    final dims = SharePngUtils.readDimensions(png);
    expect(dims?.width, 1080);
    expect(dims?.height, 1080);
  });

  testWidgets('ShareCardWidget exports exact 1080x1080 PNG', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: RepaintBoundary(
            key: key,
            child: ShareCardWidget(
              model: _sampleModel(),
              aspect: ShareCardAspect.ratio1x1,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    ShareCaptureResult? captured;
    await tester.runAsync(() async {
      captured = await ShareCardCapture.capturePng(
        key,
        aspect: ShareCardAspect.ratio1x1,
      );
    });
    expect(captured, isNotNull);
    final result = captured!;
    expect(result.width, 1080);
    expect(result.height, 1080);
    expect(result.dimensionsMatch, isTrue);
    expect(result.pngHeaderValid, isTrue);
  });

  testWidgets('ShareCardWidget exports exact 1080x1920 PNG for 9:16', (tester) async {
    final binding = tester.binding;
    await binding.setSurfaceSize(const Size(400, 720));
    addTearDown(() => binding.setSurfaceSize(null));

    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: RepaintBoundary(
            key: key,
            child: ShareCardWidget(
              model: _sampleModel(),
              aspect: ShareCardAspect.ratio9x16,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    ShareCaptureResult? captured;
    await tester.runAsync(() async {
      captured = await ShareCardCapture.capturePng(
        key,
        aspect: ShareCardAspect.ratio9x16,
      );
    });
    expect(captured?.width, 1080);
    expect(captured?.height, 1920);
    expect(captured?.pngHeaderValid, isTrue);
  });

  testWidgets('Qingming card uses solemn palette', (tester) async {
    final bundle = ContentRepository.instance.poemForFestivalId('tf_qingming')!;
    final model = _sampleModel(bundle: bundle, festivalId: 'tf_qingming');
    expect(model.isSolemn, isTrue);
    expect(model.palette, ShareCardPalette.solemn);

    await tester.pumpWidget(
      MaterialApp(
        home: ShareCardWidget(model: model, aspect: ShareCardAspect.ratio1x1),
      ),
    );
    expect(find.text('祭祀用语，请尊重习俗'), findsOneWidget);
    expect(find.textContaining('清明时节雨纷纷'), findsOneWidget);
  });

  test('caption included in plain text share', () {
    final model = _sampleModel().copyWith(caption: '爸妈记得带伞');
    expect(model.buildPlainTextShare(), contains('爸妈记得带伞'));
  });
}
