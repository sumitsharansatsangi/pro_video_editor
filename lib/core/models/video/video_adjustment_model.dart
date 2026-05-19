// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pro_video_editor/shared/utils/parser/double_parser.dart';

/// Typed colour-grading adjustments for brightness, contrast, saturation,
/// exposure, warmth, tint, and sharpness.
///
/// All values are deltas from the neutral (no-op) state.
/// Platforms that do not support a specific adjustment will silently skip it.
class VideoAdjustment {
  /// Creates a [VideoAdjustment].
  ///
  /// All parameters are optional. Omitting a parameter (or passing `null`)
  /// means that adjustment is not applied.
  const VideoAdjustment({
    this.brightness,
    this.contrast,
    this.saturation,
    this.exposure,
    this.warmth,
    this.tint,
    this.sharpen,
  })  : assert(
          brightness == null || (brightness >= -1.0 && brightness <= 1.0),
          'brightness must be in range -1.0 to 1.0',
        ),
        assert(
          contrast == null || (contrast >= -1.0 && contrast <= 1.0),
          'contrast must be in range -1.0 to 1.0',
        ),
        assert(
          saturation == null || (saturation >= -1.0 && saturation <= 1.0),
          'saturation must be in range -1.0 to 1.0',
        ),
        assert(
          exposure == null || (exposure >= -3.0 && exposure <= 3.0),
          'exposure must be in range -3.0 to 3.0 EV',
        ),
        assert(
          warmth == null || (warmth >= -1.0 && warmth <= 1.0),
          'warmth must be in range -1.0 to 1.0',
        ),
        assert(
          tint == null || (tint >= -1.0 && tint <= 1.0),
          'tint must be in range -1.0 to 1.0',
        ),
        assert(
          sharpen == null || (sharpen >= 0.0 && sharpen <= 1.0),
          'sharpen must be in range 0.0 to 1.0',
        );

  /// Brightness adjustment in range -1.0 (darkest) to 1.0 (brightest).
  /// 0.0 is neutral.
  final double? brightness;

  /// Contrast adjustment in range -1.0 (flat) to 1.0 (max contrast).
  /// 0.0 is neutral.
  final double? contrast;

  /// Saturation adjustment in range -1.0 (greyscale) to 1.0 (vivid).
  /// 0.0 is neutral.
  final double? saturation;

  /// Exposure adjustment in stops (EV), range -3.0 to 3.0. 0.0 is neutral.
  final double? exposure;

  /// Colour temperature shift. -1.0 is cooler (blue), 1.0 is warmer (orange).
  /// 0.0 is neutral.
  final double? warmth;

  /// Green–magenta tint shift. -1.0 is green, 1.0 is magenta. 0.0 is neutral.
  final double? tint;

  /// Sharpening amount from 0.0 (none) to 1.0 (maximum).
  final double? sharpen;

  /// Returns `true` if no adjustment is set (all fields are null).
  bool get isEmpty =>
      brightness == null &&
      contrast == null &&
      saturation == null &&
      exposure == null &&
      warmth == null &&
      tint == null &&
      sharpen == null;

  /// Converts this adjustment into a serialisable map.
  Map<String, dynamic> toMap() {
    return {
      'brightness': brightness,
      'contrast': contrast,
      'saturation': saturation,
      'exposure': exposure,
      'warmth': warmth,
      'tint': tint,
      'sharpen': sharpen,
    };
  }

  /// Creates a [VideoAdjustment] from a map.
  factory VideoAdjustment.fromMap(Map<String, dynamic> map) {
    return VideoAdjustment(
      brightness: tryParseDouble(map['brightness']),
      contrast: tryParseDouble(map['contrast']),
      saturation: tryParseDouble(map['saturation']),
      exposure: tryParseDouble(map['exposure']),
      warmth: tryParseDouble(map['warmth']),
      tint: tryParseDouble(map['tint']),
      sharpen: tryParseDouble(map['sharpen']),
    );
  }

  /// Converts this adjustment to JSON.
  String toJson() => json.encode(toMap());

  /// Creates a [VideoAdjustment] from JSON.
  factory VideoAdjustment.fromJson(String source) =>
      VideoAdjustment.fromMap(json.decode(source) as Map<String, dynamic>);

  VideoAdjustment copyWith({
    double? brightness,
    double? contrast,
    double? saturation,
    double? exposure,
    double? warmth,
    double? tint,
    double? sharpen,
  }) {
    return VideoAdjustment(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      exposure: exposure ?? this.exposure,
      warmth: warmth ?? this.warmth,
      tint: tint ?? this.tint,
      sharpen: sharpen ?? this.sharpen,
    );
  }

  @override
  String toString() =>
      'VideoAdjustment(brightness: $brightness, contrast: $contrast, '
      'saturation: $saturation, exposure: $exposure, warmth: $warmth, '
      'tint: $tint, sharpen: $sharpen)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoAdjustment &&
        other.brightness == brightness &&
        other.contrast == contrast &&
        other.saturation == saturation &&
        other.exposure == exposure &&
        other.warmth == warmth &&
        other.tint == tint &&
        other.sharpen == sharpen;
  }

  @override
  int get hashCode =>
      brightness.hashCode ^
      contrast.hashCode ^
      saturation.hashCode ^
      exposure.hashCode ^
      warmth.hashCode ^
      tint.hashCode ^
      sharpen.hashCode;
}
