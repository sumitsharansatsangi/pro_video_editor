import 'package:flutter_test/flutter_test.dart';
import 'package:pro_video_editor/pro_video_editor.dart';

void main() {
  group('VideoEditorCapabilities', () {
    test('supports stable and experimental features', () {
      const capabilities = VideoEditorCapabilities(
        platform: 'test',
        supportedFeatures: {VideoEditorFeature.metadata},
        experimentalFeatures: {VideoEditorFeature.blur},
      );

      expect(capabilities.supports(VideoEditorFeature.metadata), isTrue);
      expect(capabilities.supports(VideoEditorFeature.blur), isTrue);
      expect(capabilities.isExperimental(VideoEditorFeature.blur), isTrue);
      expect(capabilities.supports(VideoEditorFeature.renderVideo), isFalse);
    });

    test('unsupportedFeatures excludes stable and experimental features', () {
      const capabilities = VideoEditorCapabilities(
        platform: 'test',
        supportedFeatures: {VideoEditorFeature.metadata},
        experimentalFeatures: {VideoEditorFeature.blur},
      );

      expect(
        capabilities.unsupportedFeatures,
        isNot(contains(VideoEditorFeature.metadata)),
      );
      expect(
        capabilities.unsupportedFeatures,
        isNot(contains(VideoEditorFeature.blur)),
      );
      expect(
        capabilities.unsupportedFeatures,
        contains(VideoEditorFeature.renderVideo),
      );
    });
  });

  group('UnsupportedFeatureException', () {
    test('includes feature and platform in message', () {
      const exception = UnsupportedFeatureException(
        feature: VideoEditorFeature.renderVideo,
        platform: 'web',
      );

      expect(exception.toString(), contains('renderVideo'));
      expect(exception.toString(), contains('web'));
    });
  });
}
