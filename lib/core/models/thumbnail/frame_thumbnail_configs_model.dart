import 'thumbnail_base_abstract.dart';

/// Configuration model for extracting a single frame at a timestamp.
///
/// This is useful for preview scrubbing, still-frame export, and workflows
/// where the caller already knows the exact timestamp to capture.
class FrameThumbnailConfigs extends ThumbnailBase {
  /// Creates a [FrameThumbnailConfigs] instance.
  FrameThumbnailConfigs({
    required super.video,
    required super.outputSize,
    super.outputFormat,
    super.boxFit,
    super.id,
    super.jpegQuality,
    required this.timestamp,
  }) : assert(!timestamp.isNegative, 'timestamp must not be negative');

  /// The timestamp to capture from the video.
  final Duration timestamp;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jpegQuality': jpegQuality,
      'boxFit': boxFit.name,
      'outputFormat': outputFormat.name,
      'outputWidth': outputSize.width.round(),
      'outputHeight': outputSize.height.round(),
      'timestamps': [timestamp.inMicroseconds],
    };
  }
}
