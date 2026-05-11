import 'package:flutter_test/flutter_test.dart';
import 'package:pro_video_editor/pro_video_editor.dart';

void main() {
  group('BlurFilter', () {
    test('toMap serializes all fields', () {
      final filter = BlurFilter(
        blur: 2.5,
        startTime: Duration(seconds: 1),
        endTime: Duration(seconds: 3),
      );

      final map = filter.toMap();

      expect(map['blur'], 2.5);
      expect(map['startUs'], 1000000);
      expect(map['endUs'], 3000000);
    });

    test('fromMap parses numeric values', () {
      final filter = BlurFilter.fromMap({
        'blur': '1.5',
        'startUs': '500000',
        'endUs': 1500000,
      });

      expect(filter.blur, 1.5);
      expect(filter.startTime, const Duration(milliseconds: 500));
      expect(filter.endTime, const Duration(milliseconds: 1500));
    });

    test('json roundtrip preserves data', () {
      final filter = BlurFilter(blur: 3);

      final restored = BlurFilter.fromJson(filter.toJson());

      expect(restored.blur, 3);
      expect(restored.startTime, isNull);
      expect(restored.endTime, isNull);
    });

    test('rejects negative blur', () {
      expect(() => BlurFilter(blur: -1), throwsAssertionError);
    });
  });
}
