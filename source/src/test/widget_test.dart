import 'package:flutter_test/flutter_test.dart';
import 'package:lianji/core/content/content_repository.dart';
import 'package:lianji/core/content/poem_resolver.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    ContentRepository.instance.resetForTest();
    await ContentRepository.instance.init();
  });

  test('loads full offline content library', () {
    expect(ContentRepository.instance.poemCount, 68);
    expect(ContentRepository.instance.blessingCount, greaterThanOrEqualTo(69));
  });

  test('端午农历五月初五解析为 tf_duanwu', () {
    final id = PoemResolver.festivalIdForDate(DateTime(2026, 6, 19));
    expect(id, 'tf_duanwu');
  });
}
