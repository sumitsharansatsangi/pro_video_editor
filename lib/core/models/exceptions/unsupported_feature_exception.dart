import '../platform/video_editor_feature.dart';

/// Exception thrown when a platform does not support a requested feature.
class UnsupportedFeatureException implements Exception {
  /// Creates an [UnsupportedFeatureException].
  const UnsupportedFeatureException({
    required this.feature,
    required this.platform,
    this.message,
  });

  /// The unsupported feature.
  final VideoEditorFeature feature;

  /// The platform where the feature was requested.
  final String platform;

  /// Optional extra detail about the missing support.
  final String? message;

  @override
  String toString() {
    final suffix = message == null ? '' : ': $message';
    return 'UnsupportedFeatureException('
        '${feature.name} is not supported on $platform$suffix'
        ')';
  }
}
