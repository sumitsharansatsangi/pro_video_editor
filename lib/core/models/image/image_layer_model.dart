// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:pro_video_editor/shared/models/time_range_mixin.dart';
import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

import 'editor_layer_image_model.dart';
import 'layer_animation_model.dart';

/// A model representing a video overlay layer with timing information.
class ImageLayer with TimeRangeMixin {
  /// Creates a [ImageLayer] with the given [image], [startTime],
  /// and optional [endTime].
  const ImageLayer({
    required this.image,
    this.startTime,
    this.endTime,
    this.offset,
    this.size,
    this.animations = const [],
    this.rotation = 0,
    this.opacity = 1,
    this.zIndex = 0,
    this.anchor,
    this.blendMode = 'sourceOver',
  }) : assert(
         startTime == null || endTime == null || startTime < endTime,
         'startTime must be before endTime',
       ),
       assert(opacity >= 0 && opacity <= 1, 'opacity must be between 0 and 1');

  /// The image to overlay on the video.
  final EditorLayerImage image;

  @override
  final Duration? startTime;

  @override
  final Duration? endTime;

  /// Position offset from the top-left corner of the video frame, in pixels.
  ///
  /// [Offset.dx] is the horizontal offset from the left edge.
  /// [Offset.dy] is the vertical offset from the top edge.
  ///
  /// When `null`, the image is stretched to fill the entire video frame.
  /// When set to a specific value (e.g., [Offset.zero]), the image is
  /// placed at that position at its original size.
  final Offset? offset;

  /// The display size of the image layer, in pixels.
  ///
  /// [Size.width] is the target width of the image.
  /// [Size.height] is the target height of the image.
  ///
  /// When `null`, the image is used at its original size (or stretched to
  /// fill the frame when [offset] is also `null`).
  final Size? size;

  /// Animations to apply to this layer (e.g. fade, slide, scale).
  ///
  /// Multiple animations can be combined. Each animation specifies its
  /// [LayerAnimation.phase] (in or out), [LayerAnimation.duration],
  /// and optional [LayerAnimation.curve].
  final List<LayerAnimation> animations;

  /// Clockwise rotation in degrees.
  final double rotation;

  /// Layer opacity from 0.0 (transparent) to 1.0 (opaque).
  final double opacity;

  /// Draw order for overlapping layers. Higher values render above lower ones.
  final int zIndex;

  /// Anchor point within the layer, normalized from 0.0 to 1.0.
  ///
  /// `Offset(0, 0)` is top-left, `Offset(0.5, 0.5)` is center, and
  /// `Offset(1, 1)` is bottom-right. When null, positioned layers use center
  /// anchoring to preserve the original behavior.
  final Offset? anchor;

  /// Blend mode intent for platforms that support it.
  ///
  /// Android currently renders image layers with normal source-over blending.
  final String blendMode;

  ImageLayer copyWith({
    EditorLayerImage? image,
    Duration? startTime,
    Duration? endTime,
    Offset? offset,
    Size? size,
    List<LayerAnimation>? animations,
    double? rotation,
    double? opacity,
    int? zIndex,
    Offset? anchor,
    String? blendMode,
  }) {
    return ImageLayer(
      image: image ?? this.image,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      offset: offset ?? this.offset,
      size: size ?? this.size,
      animations: animations ?? this.animations,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      anchor: anchor ?? this.anchor,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image.toMap(),
      'startTime': startTime?.inMicroseconds,
      'endTime': endTime?.inMicroseconds,
      'offset': offset != null ? {'dx': offset!.dx, 'dy': offset!.dy} : null,
      'size': size != null
          ? {'width': size!.width, 'height': size!.height}
          : null,
      'animations': animations.map((a) => a.toMap()).toList(),
      'rotation': rotation,
      'opacity': opacity,
      'zIndex': zIndex,
      'anchor': anchor != null ? {'dx': anchor!.dx, 'dy': anchor!.dy} : null,
      'blendMode': blendMode,
    };
  }

  factory ImageLayer.fromMap(Map<String, dynamic> map) {
    return ImageLayer(
      image: EditorLayerImage.fromMap(map['image'] as Map<String, dynamic>),
      startTime: map['startTime'] != null
          ? Duration(microseconds: safeParseInt(map['startTime']))
          : null,
      endTime: map['endTime'] != null
          ? Duration(microseconds: safeParseInt(map['endTime']))
          : null,
      offset: map['offset'] != null
          ? Offset(
              safeParseDouble((map['offset'] as Map<String, dynamic>)['dx']),
              safeParseDouble((map['offset'] as Map<String, dynamic>)['dy']),
            )
          : null,
      size: map['size'] != null
          ? Size(
              safeParseDouble((map['size'] as Map<String, dynamic>)['width']),
              safeParseDouble((map['size'] as Map<String, dynamic>)['height']),
            )
          : null,
      animations:
          (map['animations'] as List<dynamic>?)
              ?.map((a) => LayerAnimation.fromMap(a as Map<String, dynamic>))
              .toList() ??
          const [],
      rotation: tryParseDouble(map['rotation']) ?? 0,
      opacity: tryParseDouble(map['opacity']) ?? 1,
      zIndex: map['zIndex'] != null ? safeParseInt(map['zIndex']) : 0,
      anchor: map['anchor'] != null
          ? Offset(
              safeParseDouble((map['anchor'] as Map<String, dynamic>)['dx']),
              safeParseDouble((map['anchor'] as Map<String, dynamic>)['dy']),
            )
          : null,
      blendMode: map['blendMode'] as String? ?? 'sourceOver',
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageLayer.fromJson(String source) =>
      ImageLayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ImageLayer('
        'image: $image, '
        'startTime: $startTime, '
        'endTime: $endTime, '
        'offset: $offset, '
        'size: $size, '
        'animations: $animations, '
        'rotation: $rotation, '
        'opacity: $opacity, '
        'zIndex: $zIndex, '
        'anchor: $anchor, '
        'blendMode: $blendMode'
        ')';
  }

  @override
  bool operator ==(covariant ImageLayer other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.offset == offset &&
        other.size == size &&
        listEquals(other.animations, animations) &&
        other.rotation == rotation &&
        other.opacity == opacity &&
        other.zIndex == zIndex &&
        other.anchor == anchor &&
        other.blendMode == blendMode;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        offset.hashCode ^
        size.hashCode ^
        animations.hashCode ^
        rotation.hashCode ^
        opacity.hashCode ^
        zIndex.hashCode ^
        anchor.hashCode ^
        blendMode.hashCode;
  }
}
