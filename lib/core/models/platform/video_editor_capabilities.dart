import 'video_editor_feature.dart';

/// Describes which editor features are available on a platform.
class VideoEditorCapabilities {
  /// Creates a [VideoEditorCapabilities] instance.
  const VideoEditorCapabilities({
    required this.platform,
    this.supportedFeatures = const {},
    this.experimentalFeatures = const {},
  });

  /// Platform name, for example `android`, `ios`, `macos`, `windows`, `linux`,
  /// or `web`.
  final String platform;

  /// Stable features supported by the current platform implementation.
  final Set<VideoEditorFeature> supportedFeatures;

  /// Features that are implemented but may vary by device, codec, or platform.
  final Set<VideoEditorFeature> experimentalFeatures;

  /// All features exposed by this package.
  static const allFeatures = VideoEditorFeature.values;

  /// Returns `true` when [feature] is supported, including experimental
  /// support.
  bool supports(VideoEditorFeature feature) {
    return supportedFeatures.contains(feature) ||
        experimentalFeatures.contains(feature);
  }

  /// Returns `true` when [feature] is experimental on this platform.
  bool isExperimental(VideoEditorFeature feature) {
    return experimentalFeatures.contains(feature);
  }

  /// Features that are not supported on this platform.
  Set<VideoEditorFeature> get unsupportedFeatures {
    return allFeatures.where((feature) => !supports(feature)).toSet();
  }

  @override
  String toString() {
    return 'VideoEditorCapabilities('
        'platform: $platform, '
        'supportedFeatures: $supportedFeatures, '
        'experimentalFeatures: $experimentalFeatures'
        ')';
  }
}
