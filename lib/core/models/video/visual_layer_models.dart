// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:pro_video_editor/pro_video_editor.dart';
import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';
import 'package:pro_video_editor/shared/utils/parser/int_parser.dart';

/// Base visual layer properties shared by text, shapes, stickers, and overlays.
class VisualLayerStyle with TimeRangeMixin {
  /// Creates shared layer style data.
  const VisualLayerStyle({
    this.startTime,
    this.endTime,
    this.offset = Offset.zero,
    this.size,
    this.rotation = 0,
    this.opacity = 1,
    this.zIndex = 0,
    this.anchor = const Offset(0.5, 0.5),
    this.blendMode = 'sourceOver',
  }) : assert(
         startTime == null || endTime == null || startTime < endTime,
         'startTime must be before endTime',
       ),
       assert(opacity >= 0 && opacity <= 1, 'opacity must be between 0 and 1');

  @override
  final Duration? startTime;

  @override
  final Duration? endTime;

  /// Position from the top-left corner of the output frame, in pixels.
  final Offset offset;

  /// Optional rendered layer size, in pixels.
  final Size? size;

  /// Clockwise rotation in degrees.
  final double rotation;

  /// Opacity from 0.0 to 1.0.
  final double opacity;

  /// Draw order. Higher values render above lower values.
  final int zIndex;

  /// Normalized anchor point inside the layer.
  final Offset anchor;

  /// Blend mode intent for native renderers.
  final String blendMode;

  /// Converts this style to a platform-channel map.
  Map<String, dynamic> toMap() {
    return {
      'startUs': startTime?.inMicroseconds,
      'endUs': endTime?.inMicroseconds,
      'x': offset.dx,
      'y': offset.dy,
      'width': size?.width,
      'height': size?.height,
      'rotation': rotation,
      'opacity': opacity,
      'zIndex': zIndex,
      'anchorX': anchor.dx,
      'anchorY': anchor.dy,
      'blendMode': blendMode,
    };
  }

  /// Restores a [VisualLayerStyle] from a map.
  factory VisualLayerStyle.fromMap(Map<String, dynamic> map) {
    return VisualLayerStyle(
      startTime: map['startUs'] != null
          ? Duration(microseconds: safeParseInt(map['startUs']))
          : map['startTime'] != null
          ? Duration(microseconds: safeParseInt(map['startTime']))
          : null,
      endTime: map['endUs'] != null
          ? Duration(microseconds: safeParseInt(map['endUs']))
          : map['endTime'] != null
          ? Duration(microseconds: safeParseInt(map['endTime']))
          : null,
      offset: Offset(
        tryParseDouble(map['x']) ?? tryParseDouble(map['dx']) ?? 0,
        tryParseDouble(map['y']) ?? tryParseDouble(map['dy']) ?? 0,
      ),
      size: map['width'] != null || map['height'] != null
          ? Size(
              tryParseDouble(map['width']) ?? 0,
              tryParseDouble(map['height']) ?? 0,
            )
          : null,
      rotation: tryParseDouble(map['rotation']) ?? 0,
      opacity: tryParseDouble(map['opacity']) ?? 1,
      zIndex: map['zIndex'] != null ? safeParseInt(map['zIndex']) : 0,
      anchor: Offset(
        tryParseDouble(map['anchorX']) ?? 0.5,
        tryParseDouble(map['anchorY']) ?? 0.5,
      ),
      blendMode: map['blendMode'] as String? ?? 'sourceOver',
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VisualLayerStyle &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.offset == offset &&
        other.size == size &&
        other.rotation == rotation &&
        other.opacity == opacity &&
        other.zIndex == zIndex &&
        other.anchor == anchor &&
        other.blendMode == blendMode;
  }

  @override
  int get hashCode => Object.hash(
    startTime,
    endTime,
    offset,
    size,
    rotation,
    opacity,
    zIndex,
    anchor,
    blendMode,
  );
}

/// Horizontal text alignment for [TextLayer].
enum TextLayerAlign { left, center, right, justify }

/// A first-class text layer that native renderers can rasterize.
class TextLayer {
  /// Creates a text layer.
  const TextLayer({
    required this.text,
    this.style = const VisualLayerStyle(),
    this.fontFamily,
    this.fontSize = 24,
    this.color = '#FFFFFFFF',
    this.backgroundColor,
    this.align = TextLayerAlign.left,
    this.bold = false,
    this.italic = false,
    this.letterSpacing = 0,
    this.lineHeight,
  }) : assert(fontSize > 0, 'fontSize must be greater than 0'),
       assert(letterSpacing >= 0, 'letterSpacing must not be negative');

  /// Display text.
  final String text;

  /// Shared placement, timing, and blend properties.
  final VisualLayerStyle style;

  /// Font family name.
  final String? fontFamily;

  /// Font size in logical pixels.
  final double fontSize;

  /// Text color as ARGB hex, for example `#FFFFFFFF`.
  final String color;

  /// Optional background color as ARGB hex.
  final String? backgroundColor;

  /// Text alignment.
  final TextLayerAlign align;

  /// Whether to use a bold font weight.
  final bool bold;

  /// Whether to use italic style.
  final bool italic;

  /// Letter spacing in logical pixels.
  final double letterSpacing;

  /// Optional line-height multiplier.
  final double? lineHeight;

  Map<String, dynamic> toMap() {
    return {
      ...style.toMap(),
      'text': text,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'color': color,
      'backgroundColor': backgroundColor,
      'align': align.name,
      'bold': bold,
      'italic': italic,
      'letterSpacing': letterSpacing,
      'lineHeight': lineHeight,
    };
  }

  factory TextLayer.fromMap(Map<String, dynamic> map) {
    return TextLayer(
      text: map['text'] as String,
      style: VisualLayerStyle.fromMap(map),
      fontFamily: map['fontFamily'] as String?,
      fontSize: safeParseDouble(map['fontSize'], fallback: 24),
      color: map['color'] as String? ?? '#FFFFFFFF',
      backgroundColor: map['backgroundColor'] as String?,
      align: TextLayerAlign.values.byName(map['align'] as String? ?? 'left'),
      bold: map['bold'] as bool? ?? false,
      italic: map['italic'] as bool? ?? false,
      letterSpacing: safeParseDouble(map['letterSpacing'], fallback: 0),
      lineHeight: tryParseDouble(map['lineHeight']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextLayer.fromJson(String source) =>
      TextLayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    return other is TextLayer &&
        other.text == text &&
        other.style == style &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.align == align &&
        other.bold == bold &&
        other.italic == italic &&
        other.letterSpacing == letterSpacing &&
        other.lineHeight == lineHeight;
  }

  @override
  int get hashCode => Object.hash(
    text,
    style,
    fontFamily,
    fontSize,
    color,
    backgroundColor,
    align,
    bold,
    italic,
    letterSpacing,
    lineHeight,
  );
}

/// Shapes supported by [ShapeLayer].
enum ShapeLayerType { rectangle, circle, line, arrow, highlightBox }

/// A vector shape layer.
class ShapeLayer {
  /// Creates a shape layer.
  const ShapeLayer({
    required this.type,
    this.style = const VisualLayerStyle(),
    this.fillColor,
    this.strokeColor = '#FFFFFFFF',
    this.strokeWidth = 2,
    this.cornerRadius = 0,
  }) : assert(strokeWidth >= 0, 'strokeWidth must not be negative'),
       assert(cornerRadius >= 0, 'cornerRadius must not be negative');

  /// Shape kind.
  final ShapeLayerType type;

  /// Shared placement, timing, and blend properties.
  final VisualLayerStyle style;

  /// Optional fill color as ARGB hex.
  final String? fillColor;

  /// Stroke color as ARGB hex.
  final String strokeColor;

  /// Stroke width in pixels.
  final double strokeWidth;

  /// Corner radius for rectangle-like shapes.
  final double cornerRadius;

  Map<String, dynamic> toMap() {
    return {
      ...style.toMap(),
      'type': type.name,
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
      'cornerRadius': cornerRadius,
    };
  }

  factory ShapeLayer.fromMap(Map<String, dynamic> map) {
    return ShapeLayer(
      type: ShapeLayerType.values.byName(map['type'] as String),
      style: VisualLayerStyle.fromMap(map),
      fillColor: map['fillColor'] as String?,
      strokeColor: map['strokeColor'] as String? ?? '#FFFFFFFF',
      strokeWidth: safeParseDouble(map['strokeWidth'], fallback: 2),
      cornerRadius: safeParseDouble(map['cornerRadius'], fallback: 0),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShapeLayer &&
        other.type == type &&
        other.style == style &&
        other.fillColor == fillColor &&
        other.strokeColor == strokeColor &&
        other.strokeWidth == strokeWidth &&
        other.cornerRadius == cornerRadius;
  }

  @override
  int get hashCode => Object.hash(
    type,
    style,
    fillColor,
    strokeColor,
    strokeWidth,
    cornerRadius,
  );
}

/// A structured sticker or emoji layer.
class StickerLayer {
  /// Creates a sticker layer.
  const StickerLayer({
    required this.value,
    this.style = const VisualLayerStyle(),
    this.pack,
    this.label,
  });

  /// Emoji text, asset identifier, or sticker id.
  final String value;

  /// Shared placement, timing, and blend properties.
  final VisualLayerStyle style;

  /// Optional sticker pack name.
  final String? pack;

  /// Optional accessibility/search label.
  final String? label;

  Map<String, dynamic> toMap() {
    return {...style.toMap(), 'value': value, 'pack': pack, 'label': label};
  }

  factory StickerLayer.fromMap(Map<String, dynamic> map) {
    return StickerLayer(
      value: map['value'] as String,
      style: VisualLayerStyle.fromMap(map),
      pack: map['pack'] as String?,
      label: map['label'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StickerLayer &&
        other.value == value &&
        other.style == style &&
        other.pack == pack &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(value, style, pack, label);
}

/// A picture-in-picture video overlay layer.
class VideoOverlayLayer {
  /// Creates a video overlay layer.
  const VideoOverlayLayer({
    required this.video,
    this.style = const VisualLayerStyle(),
    this.sourceStartTime,
    this.sourceEndTime,
    this.volume = 1,
    this.fitMode = VideoFitMode.cover,
  }) : assert(volume >= 0, 'volume must be greater than or equal to 0'),
       assert(
         sourceStartTime == null ||
             sourceEndTime == null ||
             sourceStartTime < sourceEndTime,
         'sourceStartTime must be before sourceEndTime',
       );

  /// Overlay video source.
  final EditorVideo video;

  /// Shared placement, timing, and blend properties.
  final VisualLayerStyle style;

  /// Optional trim start within the overlay source.
  final Duration? sourceStartTime;

  /// Optional trim end within the overlay source.
  final Duration? sourceEndTime;

  /// Overlay audio volume.
  final double volume;

  /// How to fit the overlay into [VisualLayerStyle.size].
  final VideoFitMode fitMode;

  Future<Map<String, dynamic>> toAsyncMap() async {
    return {
      ...style.toMap(),
      'inputPath': await video.safeFilePath(),
      'sourceStartUs': sourceStartTime?.inMicroseconds,
      'sourceEndUs': sourceEndTime?.inMicroseconds,
      'volume': volume,
      'fitMode': fitMode.name,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      ...style.toMap(),
      'video': video.toMap(),
      'sourceStartTime': sourceStartTime?.inMicroseconds,
      'sourceEndTime': sourceEndTime?.inMicroseconds,
      'volume': volume,
      'fitMode': fitMode.name,
    };
  }

  factory VideoOverlayLayer.fromMap(Map<String, dynamic> map) {
    return VideoOverlayLayer(
      video: EditorVideo.fromMap(map['video'] as Map<String, dynamic>),
      style: VisualLayerStyle.fromMap(map),
      sourceStartTime: map['sourceStartTime'] != null
          ? Duration(microseconds: safeParseInt(map['sourceStartTime']))
          : null,
      sourceEndTime: map['sourceEndTime'] != null
          ? Duration(microseconds: safeParseInt(map['sourceEndTime']))
          : null,
      volume: safeParseDouble(map['volume'], fallback: 1),
      fitMode: VideoFitMode.values.byName(map['fitMode'] as String? ?? 'cover'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoOverlayLayer &&
        other.video == video &&
        other.style == style &&
        other.sourceStartTime == sourceStartTime &&
        other.sourceEndTime == sourceEndTime &&
        other.volume == volume &&
        other.fitMode == fitMode;
  }

  @override
  int get hashCode => Object.hash(
    video,
    style,
    sourceStartTime,
    sourceEndTime,
    volume,
    fitMode,
  );
}

/// Canvas settings used when changing aspect ratio or fitting content.
class BackgroundCanvas {
  /// Creates a background canvas configuration.
  const BackgroundCanvas({
    this.aspectRatioPreset = AspectRatioPreset.original,
    this.fitMode = VideoFitMode.contain,
    this.color = '#FF000000',
    this.blurBackground = false,
  });

  /// Target aspect ratio.
  final AspectRatioPreset aspectRatioPreset;

  /// How source content fits on the target canvas.
  final VideoFitMode fitMode;

  /// Background color as ARGB hex.
  final String color;

  /// Whether to fill letterbox areas with a blurred source copy.
  final bool blurBackground;

  Map<String, dynamic> toMap() {
    return {
      'aspectRatioPreset': aspectRatioPreset.name,
      'fitMode': fitMode.name,
      'color': color,
      'blurBackground': blurBackground,
    };
  }

  factory BackgroundCanvas.fromMap(Map<String, dynamic> map) {
    return BackgroundCanvas(
      aspectRatioPreset: AspectRatioPreset.values.byName(
        map['aspectRatioPreset'] as String? ?? 'original',
      ),
      fitMode: VideoFitMode.values.byName(
        map['fitMode'] as String? ?? 'contain',
      ),
      color: map['color'] as String? ?? '#FF000000',
      blurBackground: map['blurBackground'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BackgroundCanvas &&
        other.aspectRatioPreset == aspectRatioPreset &&
        other.fitMode == fitMode &&
        other.color == color &&
        other.blurBackground == blurBackground;
  }

  @override
  int get hashCode =>
      Object.hash(aspectRatioPreset, fitMode, color, blurBackground);
}

/// Resolution presets independent from bitrate presets.
enum VideoResolutionPreset {
  /// Preserve source resolution.
  original(null, null),

  /// 426x240.
  p240(426, 240),

  /// 640x360.
  p360(640, 360),

  /// 854x480.
  p480(854, 480),

  /// 1280x720.
  p720(1280, 720),

  /// 1920x1080.
  p1080(1920, 1080),

  /// 2560x1440.
  p1440(2560, 1440),

  /// 3840x2160.
  p2160(3840, 2160);

  const VideoResolutionPreset(this.width, this.height);

  /// Preset width.
  final int? width;

  /// Preset height.
  final int? height;

  /// Converts this preset to a [Size], or null for [original].
  Size? get size {
    if (width == null || height == null) return null;
    return Size(width!.toDouble(), height!.toDouble());
  }
}

/// Extension helpers for lists of visual layers.
extension VisualLayerSerialization on List<TextLayer> {
  /// Converts text layers to maps.
  List<Map<String, dynamic>> toTextLayerMaps() =>
      map((layer) => layer.toMap()).toList();
}
