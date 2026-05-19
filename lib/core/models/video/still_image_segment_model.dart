// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

import '../image/editor_layer_image_model.dart';

/// A still-image segment that renders a static frame for a given [duration].
///
/// Use [StillImageSegment] to insert title cards, thumbnails, or transitional
/// images between video clips in a composition.
///
/// **Platform support:** Not yet implemented natively. This model defines the
/// API contract; native implementations will be added per platform.
class StillImageSegment {
  /// Creates a still-image segment.
  const StillImageSegment({
    required this.image,
    required this.duration,
    this.fps = 30,
  })  : assert(
          duration > Duration.zero,
          'Segment duration must be greater than zero',
        ),
        assert(fps > 0, 'fps must be greater than 0');

  /// The source image.
  final EditorLayerImage image;

  /// How long the still image should appear in the output.
  final Duration duration;

  /// Frame rate of the generated still-image segment.
  ///
  /// **Default:** 30 fps
  final int fps;

  /// Converts this segment into a serialisable map.
  Future<Map<String, dynamic>> toAsyncMap() async {
    final bytes = await image.safeByteArray();
    return {
      'type': 'stillImage',
      'imageData': bytes,
      'durationUs': duration.inMicroseconds,
      'fps': fps,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'stillImage',
      'image': image.toMap(),
      'durationUs': duration.inMicroseconds,
      'fps': fps,
    };
  }

  factory StillImageSegment.fromMap(Map<String, dynamic> map) {
    return StillImageSegment(
      image: EditorLayerImage.fromMap(map['image'] as Map<String, dynamic>),
      duration: Duration(microseconds: safeParseInt(map['durationUs'])),
      fps: safeParseInt(map['fps'], fallback: 30),
    );
  }

  String toJson() => json.encode(toMap());

  factory StillImageSegment.fromJson(String source) =>
      StillImageSegment.fromMap(json.decode(source) as Map<String, dynamic>);

  StillImageSegment copyWith({
    EditorLayerImage? image,
    Duration? duration,
    int? fps,
  }) {
    return StillImageSegment(
      image: image ?? this.image,
      duration: duration ?? this.duration,
      fps: fps ?? this.fps,
    );
  }

  @override
  String toString() =>
      'StillImageSegment(duration: $duration, fps: $fps)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StillImageSegment &&
        other.image == image &&
        other.duration == duration &&
        other.fps == fps;
  }

  @override
  int get hashCode => image.hashCode ^ duration.hashCode ^ fps.hashCode;

  // ignore: unused_element
  static double? _unused(Map<String, dynamic> map) => tryParseDouble(map['_']);
}
